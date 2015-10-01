package TankTracker::Model::User;

use strict;

use Moose;
use Try::Tiny;
use DateTime;
use DateTime::Format::Pg;
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

sub record_last_login {
    my ( $self, $user_id, $max_attempts ) = @_;

    my $user = $self->resultset->find($user_id) or
        die qq{user #$user_id not found};

    my $attempts = $user->login_attempts();

    # If max login attempts are configured, then blow up if the
    # user has tried to login too many times...
    if ( $max_attempts and $attempts > $max_attempts ) {
        die "Too many login attempts.\n";
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

    1;
}

sub update {
    my ( $self, $user_id, $params, $prefs ) = @_;

    my $user;

    if ( $user_id ) {
        $user = $self->resultset->find($user_id) or
            die qq{user #$user_id not found};

        my $chg_password = delete $params->{'change_password'};
        my $curr_pw      = delete $params->{'current_password'};
        my $pw_1         = delete $params->{'new_password1'};
        my $pw_2         = delete $params->{'new_password2'};

        ## This should all have been taken care of within the Controller,
        ## but prefer to be paranoid about it...
        if ( $chg_password ) {
            $curr_pw or
                die qq{cannot set new password without current password\n};

            ( $self->hash_pw($curr_pw) eq $user->password() ) or
                die qq{cannot set new password - current password invalid\n};

            ( $pw_1 and $pw_2 and $pw_1 eq $pw_2 ) or
                die qq{cannot set new password: new + confirmed do not match\n};

            $params->{'password'} = $self->resultset->result_class->hash_pw($pw_1);
        }
    }
    else {
        # must be adding a new user:
        my $pw_1 = delete $params->{'new_password1'};
        my $pw_2 = delete $params->{'new_password2'};
        ( $pw_1 and $pw_2 and $pw_1 eq $pw_2 ) or
            die qq{passwords do not match\n};

        $params->{'password'} = $self->resultset->result_class->hash_pw($pw_1);
    }

    $self->txn_begin();

    try {
        if ( $user ) {
            $user->update($params);
        }
        else {
            $user = $self->resultset->create($params);
        }

        $prefs->{'user_id'} = $user->user_id();

        $self->schema->resultset('UserPreference')->update_or_create($prefs);
    }
    catch {
        $self->rollback();
        die $_;
    };

    $self->txn_commit();

    return 1;
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
