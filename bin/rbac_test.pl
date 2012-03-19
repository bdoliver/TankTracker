#!/usr/bin/perl

use strict;
use warnings;

use lib qw(./lib);

use Data::Dumper;
use TankTracker::Schema;

our $dbi_dsn    = 'dbi:Pg:dbname=TankTracker;host=localhost;port=5432';
our $dbi_user   = 'brendon';
our $dbi_pass   = undef;
our %dbi_params = ();

#sub _dumper_hook {
#    $_[0] = bless {
#      %{ $_[0] },
#      result_source => undef,
#    }, ref($_[0]);
#}
#$Data::Dumper::Freezer = '_dumper_hook';

my $schema = TankTracker::Schema->connect($dbi_dsn,
                                          $dbi_user,
                                          $dbi_pass,
                                          \%dbi_params) or
                die "DBI connect failed!\n";


my $user = $schema->resultset('TrackerUser')->find({login => 'brendon'});

#print "USER:\n", Dumper($user);
my $roles = $user->tracker_user_roles->get_column('role_id')->all();


print "Roles:\n", Dumper($roles);

