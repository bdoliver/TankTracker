package TankTracker::Model::WaterType::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use TankTracker::Model::WaterType;

sub object_class { 'TankTracker::Model::WaterType' }

__PACKAGE__->make_manager_methods('water_type');

1;

