#!/usr/bin/env perl

use strict;
use warnings;

use DateTime;

use Test::Most;
use Test::WWW::Mechanize::Catalyst;

$| = 1;

BEGIN {
    # This ensures that email generation will occur,
    # but will not be sent, allowing us to capture &
    # inspect the email's content. (HANDY DANDY!!)
    $ENV{EMAIL_SENDER_TRANSPORT} = q{Test};
}

my $now        = DateTime->now();
my $username   = sprintf('test%s%s', $now->ymd(''), $now->hms(''));
my $email_addr = $username.'@gmail.com';
my $password   = q{testpass1};

subtest 'setup' => sub {
    ok(1, qq{Test username: $username});
    ok(1, qq{Test email   : $email_addr});
};

my $ua = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'TankTracker');

subtest 'signup' => sub {
    $ua->get_ok('/', q{GET root URL});

    ok($ua->uri() =~ qr{/login$}, q{goes to login page});

    $ua->follow_link_ok({text_regex => qr{Sign up}}, q{clicked 'Sign up?' link});

    ok($ua->uri() =~ qr{/signup$}, q{goes to signup page});

    $ua->submit_form_ok({
            fields => {
                username => $username,
                email    => $email_addr,
            },
        },
        q{submit signup request}
    );

    ok($ua->uri() =~ qr{/login$}, q{returns to login page after signup submitted});
};

my $reset_path = q{};

subtest 'email' => sub {
    my @email = Email::Sender::Simple->default_transport->deliveries;
    ok(@email == 1, q{captured signup email});

    my $email = shift @email;

    ok(@{ $email->{failures}  } == 0, q{no delivery failure});
    ok(@{ $email->{successes} } == 1, q{one delivery success});
    ok($email->{successes}->[0] eq $email_addr,
        q{email delivered to expected user}
    );

    my $body = $email->{email}->get_body();

    ( $reset_path ) = ( $body =~ qr{(/password_reset\?code=\w+)}ms );

    ok($reset_path, q{Email contains password reset information});
};

subtest 'set password' => sub {
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
done_testing();
