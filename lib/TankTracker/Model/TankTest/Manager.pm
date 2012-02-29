package TankTracker::Model::TankTest::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use TankTracker::Model::TankTest;

sub object_class { 'TankTracker::Model::TankTest' }

__PACKAGE__->make_manager_methods('tank_tests');

1;

