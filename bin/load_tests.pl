#!/bin/env perl

use strict;
use warnings;

use Dancer ':script';

use FindBin qw($Bin);
use Getopt::Long qw(:config no_ignore_case bundling);

use lib "$Bin/../lib";

use TankTracker::Common::WaterTest qw(load_tests);

our ( $file, $delete );

Getopt::Long::GetOptions('file=s'   => \$file,
			 'x|delete' => \$delete);

my $count = load_tests($file, $delete);

print "Loaded $count test results\n";

