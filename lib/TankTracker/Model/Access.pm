package TankTracker::Model::Access;

use strict;

use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'TankUserAccess',
);

sub get {
    my ( $self, $user_id ) = @_;

    my $access_obj = $self->resultset->find($user_id, { 'prefetch' => 'tank' });

    my $access = $self->deflate($access_obj);

    return $access;
}


no Moose;
__PACKAGE__->meta->make_immutable();

1;
