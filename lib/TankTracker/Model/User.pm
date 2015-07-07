package TankTracker::Model::User;

use strict;

use Crypt::Eksblowfish::Bcrypt qw(bcrypt_hash en_base64);
use List::Util qw(any);
use Moose;
use Try::Tiny;
use DateTime;
use DateTime::Format::Pg;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'TrackerUser',
);

sub get {
    my ( $self, $user_id ) = @_;

    my $user_obj = $self->resultset->find($user_id, { 'prefetch' => 'preference' });

    my $prefs = $self->deflate($user_obj->preference());
    my $user  = $self->deflate($user_obj);

    delete $user->{'password'};

    $user->{'preferences'} = $prefs;

    return $user;
}

sub record_last_login {
    my ( $self, $user_id ) = @_;

    my $user = $self->resultset->find($user_id) or
        die qq{user #$user_id not found};

    $user->last_login(
        DateTime::Format::Pg->format_timestamp(
            DateTime->now('time_zone' => 'Australia/Melbourne')
        )
    );

    return $user->update();
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

            $params->{'password'} = $self->hash_pw($pw_1);
        }
    }
    else {
        # must be adding a new user:
        my $pw_1 = delete $params->{'new_password1'};
        my $pw_2 = delete $params->{'new_password2'};
        ( $pw_1 and $pw_2 and $pw_1 eq $pw_2 ) or
            die qq{passwords do not match\n};

        $params->{'password'} = $self->hash_pw($pw_1);
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

        $self->schema->resultset('Preference')->update_or_create($prefs);
    }
    catch {
        $self->rollback();
        die $_;
    };

    $self->txn_commit();

    return 1;
}

sub hash_pw {
    my ( $self, $pw ) = @_;

    return $pw
           ? en_base64(bcrypt_hash({ key_nul => 1,
                                     cost    => 8,
                                     salt    => ']+_%%^981#^!*|vB' }, $pw))
           : '';
}

sub check_password {

        my ( $self, $attempt ) = @_;

        my $ret = 0;

        if ( $attempt ) {
                my $hash = $self->hash_pw($attempt);

                $ret = ($hash eq $self->password());
        }

        return $ret;
}

sub has_role {
    my ( $self, $role ) = @_;

    $role or return 0;

    return any {
        $_->role->name() eq $role
    } $self->tracker_user_roles->all();
}

sub can_access_tank {
    my ( $self, $tank_id ) = @_;

    $tank_id or return 0;

    return any {
        $_->tank_id() eq $tank_id
    } $self->tank_user_accesses->all();
}

sub can_admin_tank {
    my ( $self, $tank_id ) = @_;

    $tank_id or return 0;

    return any {
        ( $_->tank_id() eq $tank_id ) and $_->admin()
    } $self->tank_user_accesses->all();
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;