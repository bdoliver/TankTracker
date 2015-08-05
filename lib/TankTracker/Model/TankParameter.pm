package TankTracker::Model::TankParameter;

use strict;

use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'TankParameter',
);


no Moose;
__PACKAGE__->meta->make_immutable();

1;
