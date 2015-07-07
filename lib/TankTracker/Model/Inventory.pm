package TankTracker::Model::Inventory;

use strict;

use Moose;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'Inventory',
);

# sub get {
#     my ( $self, $inventory_id ) = @_;
#
#     # Don't call find() because deflate() operates on resultset objects!
#     my $result = $self->resultset->search({inventory_id => $inventory_id});
#
#     return $self->deflate($result);
# }

sub add {
    my ( $self, $params ) = @_;

    my $item = $self->resultset->create($params);

    $self->add_diary({
        'tank_id'    => $item->tank_id(),
        'user_id'    => $item->user_id(),
        'diary_note' => q{Added inventory item #}.$item->inventory_id(),
    });

    return $self->deflate($item);
}

sub update {
    my ( $self, $inventory_id, $params ) = @_;

    my $item = $self->resultset->find($inventory_id);

    $item->update($params);

    $self->add_diary({
        'tank_id'    => $item->tank_id(),
        'user_id'    => $item->user_id(),
        'diary_note' => qq{Updated inventory item #$inventory_id},
    });

    return $self->deflate($item);
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
