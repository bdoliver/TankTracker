package TankTracker::Model::WaterTestParameter;

use strict;

use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'WaterTestParameter',
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
