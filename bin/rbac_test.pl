#!/bin/env perl

use strict;
use warnings;

use lib qw(./lib);

use Dancer ':script';

use Dancer::Plugin::Auth::RBAC;

use Data::Dumper;
use TankTracker::Schema;

## Configure database connection from Dancer's config.yml - SWEET!!
our $dbi_dsn    = config->{plugins}->{DBIC}->{default}->{dsn};
our $dbi_user   = config->{plugins}->{DBIC}->{default}->{user};
our $dbi_pass   = config->{plugins}->{DBIC}->{default}->{pass};
our $dbi_params = config->{plugins}->{DBIC}->{default}->{options};

my $login = shift or
     die "Requires user ID for testing credentials & perms.\n";

my $schema = TankTracker::Schema->connect($dbi_dsn,
                                          $dbi_user,
                                          $dbi_pass,
                                          $dbi_params) or
                die "DBI connect failed!\n";


my $user = $schema->resultset('TrackerUser')->find({login => $login});

my $roles = $user->roles();
$roles->count() or
        die "User '$login' has no roles defined!\n";

while ( my $r = $roles->next() ) {
    print "role_id: ", $r->role_id(), " = ", ref($r), " : ", $r->name(), "\n";
    my $permissions = $r->permissions(); 
    while ( my $p = $permissions->next() ) {
        print "\thas perm: ", $p->permission_id(), " / ", $p->name(), "\n";
    }
}

my $auth = auth($login, 'test1');

$auth or die "\tuser NOT authorised\n";

print "auth() returned a '", ref($auth), "' object\n";

print "User is", ( $auth->asa(1) ? '' : ' **NOT**' ), " an Admin user.\n";
print "User is", ( $auth->asa(2) ? '' : ' **NOT**' ), " a  Guest user.\n";

$auth->can('edit test');
