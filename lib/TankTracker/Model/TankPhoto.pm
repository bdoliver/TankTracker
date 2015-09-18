package TankTracker::Model::TankPhoto;

use strict;

use Moose;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'TankPhoto',
);

sub add {
    my ( $self, $params ) = @_;

    my $item = $self->resultset->create($params);

    $self->add_diary({
        'tank_id'    => $item->tank_id(),
        'user_id'    => $item->user_id(),
        'diary_note' => q{Uploaded photo: }.$item->file_name(),
    });

    return $self->deflate($item);
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
