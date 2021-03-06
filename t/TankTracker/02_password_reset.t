#!/usr/bin/env perl

use strict;
use warnings;

use DateTime;

use Test::Most;
use Test::WWW::Mechanize::Catalyst;

$| = 1;

my $user_admin;

BEGIN {
    # This ensures that email generation will occur,
    # but will not be sent, allowing us to capture &
    # inspect the email's content. (HANDY DANDY!!)
    $ENV{EMAIL_SENDER_TRANSPORT} = q{Test};

    $user_admin = q{./script/user_admin.pl};

    -x $user_admin or
        die "Tests must be executed from top-level of source tree!\n";
}

my $now        = DateTime->now();
my $username   = sprintf('test%s%s', $now->ymd(''), $now->hms(''));
my $email_addr = $username.'@gmail.com';
my $password   = q{testpass1};

subtest 'setup' => sub {
    my @user_args = ( qw(--add --role owner) );

    push @user_args, '--user', $username,
                     '--pass', $password,
                     '--email', $email_addr;

    ok(system($user_admin, @user_args) == 0, q{created test user a/c});

    ok(1, qq{username: $username});
    ok(1, qq{email   : $email_addr});
};

my $ua = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'TankTracker');

sub _test_email {
    my ( $email_idx ) = @_;

    ## Unfortunately, @email is the aggregation of ALL emails
    ## generated by testing, so $email_idx specifies which one
    ## we are interested in for this specific test instance.

    my $reset_path = q{};

    subtest 'email' => sub {
        my @email = Email::Sender::Simple->default_transport->deliveries;

        ok(@email == $email_idx + 1, q{captured password reset email});

        my $email = $email[$email_idx];

        ok(@{ $email->{failures}  } == 0, q{no delivery failure});
        ok(@{ $email->{successes} } == 1, q{one delivery success});
        ok($email->{successes}->[0] eq $email_addr,
            q{email delivered to expected user}
        );

        my $body = $email->{email}->get_body();

        ( $reset_path ) = ( $body =~ qr{(/password_reset\?code=\w+)}ms );

        ok($reset_path, q{Email contains password reset information});
    };

    return $reset_path;
}

sub _reset_password {
    my ( $reset_path, $password ) = @_;

    subtest 'reset password' => sub {
        $ua->get_ok($reset_path, qq{GET password reset URL ($reset_path)});

        ok($ua->uri() =~ qr{/password_reset\?code=}, q{goes to password reset page});

        $ua->submit_form_ok({
                fields => {
                    check_password_1 => $password,
                    check_password_2 => $password,
                },
            },
            q{submit change password form}
        );
        ok($ua->uri() =~ qr{/login$}, q{returns to login page after password change});
    };
}

sub _login {
    my ( $password ) = @_;

    subtest 'login' => sub {
        $ua->submit_form_ok({
                fields => {
                    username => $username,
                    password => $password,
                },
            },
            q{submit login form}
        );
        ok($ua->uri() =~ qr{/tank/}, q{login successful, goes to tank page});
    };
}

subtest 'reset by username' => sub {
    $ua->get_ok('/', q{GET root URL});

    ok($ua->uri() =~ qr{/login$}, q{goes to login page});

    $ua->follow_link_ok(
        {text_regex => qr{Problem logging in}},
        q{clicked 'Problem logging in?' link},
    );

    ok($ua->uri() =~ qr{/password_reset$}, q{goes to password reset page});

    $ua->submit_form_ok({
            fields => {
                username => $username,
            },
        },
        q{submit password reset request}
    );

    ok($ua->uri() =~ qr{/login$}, q{returns to login page after request submitted});

    $ua->text_contains(
        q{An email has been sent with instructions to reset your login.},
        q{page has confirmation message that email was sent},
    );

    my $reset_path = _test_email(0);

    # new password - just reverse the old one
    $password = reverse $password;

    _reset_password($reset_path, $password);

    _login($password);
};

$ua->get_ok('/logout', q{clicked 'Logout' button});
ok($ua->uri() =~ qr{/login$}, q{goes to login page});

subtest 'reset by email address' => sub {
    $ua->get_ok('/', q{GET root URL});

    ok($ua->uri() =~ qr{/login$}, q{goes to login page});

    $ua->follow_link_ok(
        {text_regex => qr{Problem logging in}},
        q{clicked 'Problem logging in?' link},
    );

    ok($ua->uri() =~ qr{/password_reset$}, q{goes to password reset page});

    $ua->submit_form_ok({
            fields => {
                username => $email_addr,
            },
        },
        q{submit password reset request}
    );

    ok($ua->uri() =~ qr{/login$}, q{returns to login page after request submitted});

    $ua->text_contains(
        q{An email has been sent with instructions to reset your login.},
        q{page has confirmation message that email was sent},
    );

    my $reset_path = _test_email(1);

    # new password - just reverse the old one
    # (yes, this means the new 'new' password
    #  is back to what it was originally)
    $password = reverse $password;

    _reset_password($reset_path, $password);

    _login($password);
};

done_testing();
