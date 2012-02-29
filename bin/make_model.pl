#!/usr/bin/perl -w

use strict;

use Rose::DB::Object::Loader;

use FindBin;
use lib "$FindBin::Bin/../lib";

my $db_name = 'TankTracker';
my $db_host = 'localhost';
my $db_port = 5432;
my $db_user = 'brendon';
my $db_pass = undef;

my $loader =  Rose::DB::Object::Loader->new(
             # control databse access
             db_dsn        => "dbi:Pg:dbname=$db_name;host=$db_host;port=$db_port",
             db_username   => $db_user,
             db_password   => $db_pass,
             db_options    => { AutoCommit => 1, ChopBlanks => 1 },
             # control generation
             class_prefix  => 'TankTracker::Model',
             base_class    => 'TankTracker::Model::Object',
             with_managers => 1);

$loader->make_modules(with_unique_keys    => 1,
                      with_relationships  => 1,
                      require_primary_key => 0,
                      module_dir          => "$FindBin::Bin/../lib");

