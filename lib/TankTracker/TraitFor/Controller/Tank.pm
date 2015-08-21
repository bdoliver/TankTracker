package TankTracker::TraitFor::Controller::Tank;

use MooseX::MethodAttributes::Role;
use DateTime::Format::Pg;
use namespace::autoclean;

sub base :Chained('/') :PathPart('tank') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    if ( $c->request->path() =~ qr{tank/.+} ) {
        $c->stash->{'back_link'} = {
            'path' => '/tank',
            'text' => 'Back',
        };
    }

    return 1;
}

sub get_tank :Chained('base') :PathPart('') CaptureArgs(1) {
    my ( $self, $c, $tank_id ) = @_;

    if ( ! $tank_id ) {
        my $error = qq{Missing tank_id!};
        $c->log->fatal("get_error() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( $tank_id !~ qr{\A \d+ \z}msx ) {
        my $error = qq{Invalid tank_id '$tank_id'!};
        $c->log->fatal("get_tank() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( my $tank = $c->model('Tank')->get($tank_id) ) {
        if ( $c->user->user_id() != $tank->{'owner_id'} ) {
            my $error = qq{Tank requested '$tank_id': does not belong to current user!};
            $c->log->fatal("get_error() $error");
            $c->error($error);
            $c->detach();
            return;
        }

        # fetch the test attributes for this tank:
        my $params = $c->model('TankWaterTestParameter')->list(
            {
                'tank_id' => $tank_id,
            },
            {
                'order_by' => { '-asc' => [ qw( param_order parameter_id ) ] },
            },
        );

        $tank->{'test_params'} = $params || [];

        # wrap all tank-specific pages with the tank-select menu
        $c->stash->{'template_wrappers'} = [ 'tank/select.tt' ];

        $c->stash->{'tank'} = $tank;
    }
    else {
        my $error = qq{Tank requested '$tank_id': not found in database!};
        $c->log->fatal("get_tank() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    return 1;
}

1;
