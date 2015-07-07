package TankTracker::Model::Diary;

use strict;

use Moose;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'Diary',
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
