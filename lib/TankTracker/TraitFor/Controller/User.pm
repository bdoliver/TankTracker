package TankTracker::TraitFor::Controller::User;

use MooseX::MethodAttributes::Role;
use namespace::autoclean;

sub base :Chained('/') :PathPart('user') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    return 1;
}

sub get_user :Chained('base') :PathPart('') CaptureArgs(1) {
    my ( $self, $c, $user_id ) = @_;

    if ( ! $user_id ) {
        my $error = qq{Missing user_id!};
        $c->log->fatal("get_error() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( $user_id !~ qr{\A \d+ \z}msx ) {
        my $error = qq{Invalid user_id '$user_id'!};
        $c->log->fatal("get_user() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( my $user = $c->model('User')->get($user_id) ) {
        $c->stash->{'edit_user'} = $user;
    }
    else {
        my $error = qq{User requested '$user_id': not found in database!};
        $c->log->fatal("get_user() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    return 1;
}

1;
