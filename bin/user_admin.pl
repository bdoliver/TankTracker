#!/usr/bin/perl

use strict;
use warnings;

use lib "../lib";

use TankTracker::Schema;

use Getopt::Long qw(:config no_ignore_case bundling);

our $dbi_dsn    = 'dbi:Pg:dbname=TankTracker;host=localhost;port=5432';
our $dbi_user   = 'brendon';
our $dbi_pass   = undef;
our %dbi_params = ();

our ( $login, $pass );

Getopt::Long::GetOptions('login=s' => \$login,
			 'pass=s'  => \$pass);

$login or die "Missing --login=login_name option\n";
$pass  or die "Missing --pass=password option\n";

my $schema = TankTracker::Schema->connect($dbi_dsn,
					  $dbi_user,
					  $dbi_pass,
					  \%dbi_params) or
		die "DBI connect failed!\n";


my $user = $schema->resultset('TrackerUser')->find({login => $login});

$user or die "login '$login' not found in DB!\n";

$user->password($user->hash_pw($pass));

$user->update() or die "Failed to save hashed password\n";

print "New password saved\n";

exit(0);
