package TankTracker::Model::DB::AutoBase1;

use strict;

use base 'Rose::DB';

__PACKAGE__->use_private_registry;

__PACKAGE__->register_db
(
  connect_options => { AutoCommit => 1, ChopBlanks => 1 },
  driver          => 'pg',
  dsn             => 'dbi:Pg:dbname=TankTracker;host=localhost;port=5432',
  username        => 'brendon',
);

1;
