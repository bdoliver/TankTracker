package TankTracker::Model::TankDiary::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use TankTracker::Model::TankDiary;

sub object_class { 'TankTracker::Model::TankDiary' }

__PACKAGE__->make_manager_methods('tank_diary');

1;

