package TankTracker::Model::Session::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use TankTracker::Model::Session;

sub object_class { 'TankTracker::Model::Session' }

__PACKAGE__->make_manager_methods('session');

1;

