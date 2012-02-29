#!/usr/bin/perl -w

use Proc::Daemon;
use Proc::PID::File;

my $env = shift || 'development';

my $dir;

if ( $env =~ m|^prod|i ) {
	$dir = "/opt";
}
else {
	$dir = "$ENV{HOME}/DEVEL";
}

my $TrackerDir = "$dir/TankTracker";
-d $TrackerDir or
	die "$0: $TrackerDir not found!\n";

die "$0 already running!" if
  (Proc::PID::File->running(name => 'TankTracker',
                            dir  => "$TrackerDir/log"));

print STDERR "TankTracker daemonizing\n";
Proc::Daemon->Init({ work_dir => $TrackerDir,
		     exec_command => "nohup plackup -E $env -s Starman -a $TrackerDir/bin/app.pl -p 3000 > ./logs/starman.log 2>&1"
		   });     

