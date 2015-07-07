package TankTracker::Model::Tank;

use strict;

use Moose;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'Tank',
);

sub update {
    my ( $self, $tank_id, $params ) = @_;

    my $tank = $self->resultset->find($tank_id);

    $tank->update($params);

    $self->add_diary({
        'tank_id'    => $tank_id,
        'user_id'    => $tank->owner_id(),
        'diary_note' => 'Updated tank details',
    });

    return $self->deflate($tank);
}

sub add {
    my ( $self, $params ) = @_;

    my $tank = $self->resultset->create($params);

    # created a new tank record so create an access record for the user:
    $self->schema->resultset('TankUserAccess')->create({
        'tank_id' => $tank->tank_id(),
        'user_id' => $tank->owner_id(),
        'admin'   => 1, # owner is always admin of their tank
    });

    $self->add_diary({
        'tank_id'    => $tank->tank_id(),
        'user_id'    => $tank->owner_id(),
        'diary_note' => 'Created tank',
    });

    return $self->deflate($tank);
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
