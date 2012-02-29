package TankTracker::Model::Tank::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use TankTracker::Model::Tank;

sub object_class { 'TankTracker::Model::Tank' }

__PACKAGE__->make_manager_methods('tank');

1;

