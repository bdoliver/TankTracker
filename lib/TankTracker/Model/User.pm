package TankTracker::Model::User;

use strict;

use Moose;
use Carp;
use DateTime;
use DateTime::Format::Pg;
use Session::Token;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'User',
);

sub get {
    my ( $self, $user_id ) = @_;

    my $user_obj = $self->resultset->find($user_id, { 'prefetch' => 'user_preference' });

    my $prefs = $self->deflate($user_obj->user_preference());
    my $user  = $self->deflate($user_obj);

    delete $user->{'password'};

    $user->{'preferences'} = $prefs;

    return $user;
}

sub get_by_reset_code {
    my ( $self, $reset_code, $no_deflate ) = @_;

    my $user = $self->resultset->find(
                { 'reset_code' => $reset_code},
                { 'key'        => 'reset_code_idx' },
               );

    return $no_deflate ? $user : $self->deflate($user);
}

sub days_since_last_change {
    my ( $self, $user_id ) = @_;

    my $user = $self->resultset->find($user_id) or
        croak qq{days_since_last_change() user #$user_id not found};

    my $last_changed = $user->last_pwchange();

    $last_changed or return;

    return $last_changed->delta_days(
        DateTime->now('time_zone' => 'Australia/Melbourne')
    )->in_units('days');
}

sub is_password_expired {
    my ( $self, $user_id, $expiry ) = @_;

    return 0 unless $expiry;

    my $days_since_last_change = $self->days_since_last_change($user_id);

    ( defined $days_since_last_change ) or
        return 1; # never changed, therefore expired

    return $days_since_last_change > $expiry ? 1 : 0;
}

sub record_last_login {
    my ( $self, $user_id, $max_attempts ) = @_;

    my $user = $self->resultset->find($user_id) or
        croak qq{user #$user_id not found};

    my $attempts = $user->login_attempts();

    # If max login attempts are configured, then blow up if the
    # user has tried to login too many times...
    if ( $max_attempts and $attempts > $max_attempts ) {
        croak "Too many login attempts.\n";
    }

    $user->last_login(
        DateTime::Format::Pg->format_timestamp(
            DateTime->now('time_zone' => 'Australia/Melbourne')
        )
    );
    # also reset the user's login_attempt count:
    $user->login_attempts(0);

    return $user->update();
}

sub update_login_attempts {
    my ( $self, $arg ) = @_;

    try {

        my $user = $self->resultset->search(
            {
                'username' => $arg,
            },
            {
                'email'    => $arg,
            },
        )->single();

        if ( $user ) {
            my $attempts = $user->login_attempts() + 1;
            $user->login_attempts($attempts);
            $user->update();
        }
    }
    catch {
        # we don't care if this fails...
    };

    return 1;
}

sub update {
    my ( $self, $user_id, $params, $prefs ) = @_;

    my $user;

    if ( $user_id ) {
        $user = $self->resultset->find($user_id) or
            croak qq{user #$user_id not found};

        ## This should all have been taken care of within the Controller,
        ## but prefer to be paranoid about it...
        if ( delete $params->{'change_password'} ) {
            my $curr_pw = delete $params->{'current_password'};
            my $pw_1    = delete $params->{'new_password1'};
            my $pw_2    = delete $params->{'new_password2'};

            $curr_pw or
                croak qq{cannot set new password without current password\n};

            ( $user->hash_str($curr_pw) eq $user->password() ) or
                croak qq{cannot set new password - current password invalid\n};

            ( $pw_1 and $pw_2 and $pw_1 eq $pw_2 ) or
                croak qq{cannot set new password: new + confirmed do not match\n};

            $params->{'password'} = $user->hash_str($pw_1);
        }
    }

    $self->txn_begin();

    try {
        if ( $user ) {
            $user->update($params);
        }
        else {
            $user = $self->resultset->create($params);
        }

        if ( $prefs ) {
            $prefs->{'user_id'} = $user->user_id();

            $self->schema->resultset('UserPreference')->update_or_create($prefs);
        }
    }
    catch {
        $self->rollback();
        croak $_;
    };

    $self->txn_commit();

    return 1;
}

sub signup {
    my ( $self, $args ) = @_;

    $args->{reset_code}    = Session::Token->new()->get();
    # since password can't be blank, just plug the reset code
    # in as a temporary measure.
    $args->{password}      = $args->{reset_code};
    $args->{role}          = 'owner';
    $args->{reset_expires} = DateTime->now()->add('hours' => 24);

    # on successful creation, return the reset_code so that it can
    # be mailed out.
    return $self->update(undef, $args, {})
           ? $args->{reset_code}
           : undef;
}

sub request_password_reset {
    my ( $self, $args ) = @_;

    my $user = $self->resultset->search($args)->first();

    if ( $user ) {
        my $reset_code    = Session::Token->new()->get();
        my $reset_expires = DateTime->now()->add('hours' => 24);
        $user->update({
            reset_code    => $reset_code,
            reset_expires => $reset_expires,
        });

        return $self->deflate($user);
    }

    return;
}

sub reset_password {
    my ( $self, $args ) = @_;

    my $reset_code = $args->{'reset_code'};
    my $user_id    = $args->{'user_id'};
    my $password   = $args->{'password'};

    ( ( $reset_code or $user_id ) and $password ) or
        croak "reset_password() requires 'password' and either 'reset_code' or 'user_id'";

    my $user = $user_id
                ? $self->resultset->find($user_id)
                : $self->get_by_reset_code($reset_code, $self->no_deflate());

    if ( $user ) {
        my $now = DateTime->now('time_zone' => 'Australia/Melbourne');
        if ( DateTime->compare($now, $user->reset_expires()) > 0 ) {
            croak "Password reset request has expired\n";
        }

        $user->update({
            password       => $user->hash_str($password),
            last_pwchange  => DateTime::Format::Pg->format_timestamp($now),
            reset_code     => undef,
            reset_expires  => undef,
            login_attempts => 0,
        });

        return $self->deflate($user);
    }

    return;
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
