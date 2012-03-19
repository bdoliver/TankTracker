#!/usr/bin/env perl

use Modern::Perl;
use Test::More;

use lib '../lib';
use Module::Pluggable search_path => [ 'TankTracker' ];

require_ok( $_ ) for __PACKAGE__->plugins();

done_testing;

