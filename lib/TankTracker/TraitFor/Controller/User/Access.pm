package TankTracker::TraitFor::Controller::User::Access;

use MooseX::MethodAttributes::Role;
use namespace::autoclean;

sub user_can_access_tank :Private {
    my ( $self, $c, $tank_id ) = @_;

    my $user_id   = $c->user->user_id();
       $tank_id ||= $c->session->{'tank_id'};

    my $row = $c->model('Access')->get({
        tank_id => $tank_id,
        user_id => $user_id,
    });

    return $row ? 1 : 0;
}

1;
