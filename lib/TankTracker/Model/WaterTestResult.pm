package TankTracker::Model::WaterTestResult;

use strict;

use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'WaterTestResult',
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
