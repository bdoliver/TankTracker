package TankTracker::Model::Tank;

use strict;

use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'Tank',
);

## Ensures we don't pass empty strings to the database for
## certain optional tank attributes:
sub _fix_params {
    my ( $self, $params ) = @_;

    for my $p ( qw( capacity length width depth active ) ) {
        $params->{$p} ||= 0;
    }

    return $params;
}

sub _water_test_params {
    my ( $self, $tank_id, $wtp ) = @_;

    if ( $wtp ) {
        my $rs = $self->schema->resultset('TankWaterTestParameter');

        for my $wtp ( @{ $wtp } ) {
            $wtp->{'tank_id'} = $tank_id;
            $rs->update_or_create($wtp);
        }
    }

    return 1;
}

sub update {
    my ( $self, $tank_id, $params, $wtp ) = @_;

    my $tank;

    if ( $wtp ) {
        ref($wtp) eq 'ARRAY' or
            die "Tank::update() expected 3rd arg to be arrayref!\n";
    }

    try {
        $self->schema->txn_do(
            sub {
                $tank = $self->resultset->find($tank_id);

                $tank->update($self->_fix_params($params));

                # update water test parameters for this tank:
                $self->_water_test_params($tank_id, $wtp);
            }
        );

        $self->add_diary({
            'tank_id'    => $tank_id,
            'user_id'    => $tank->owner_id(),
            'diary_note' => 'Updated tank details',
        });
    }
    catch {
        die $_;
    };

    return $self->deflate($tank);
}

sub add {
    my ( $self, $params, $wtp ) = @_;

    if ( $wtp ) {
        ref($wtp) eq 'ARRAY' or
            die "Tank::add() expected 2rd arg to be arrayref!\n";
    }

    my $tank;

    try {
        $self->schema->txn_do(
            sub {
                $tank = $self->resultset->create($self->_fix_params($params));

                # set up water test parameters for this tank:
                $self->_water_test_params($tank->tank_id(), $wtp);

                # created a new tank record so create an access record for the user:
                $self->schema->resultset('TankUserAccess')->create({
                    'tank_id' => $tank->tank_id(),
                    'user_id' => $tank->owner_id(),
                    'admin'   => 1, # owner is always admin of their tank
                });
            }
        );

        $self->add_diary({
            'tank_id'    => $tank->tank_id(),
            'user_id'    => $tank->owner_id(),
            'diary_note' => 'Created tank',
        });
    }
    catch {
        die $_;
    };

    return $self->deflate($tank);
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
