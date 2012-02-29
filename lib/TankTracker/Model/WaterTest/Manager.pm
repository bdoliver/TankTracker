package TankTracker::Model::WaterTest::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use TankTracker::Model::WaterTest;

sub object_class { 'TankTracker::Model::WaterTest' }

__PACKAGE__->make_manager_methods('water_tests');

1;

