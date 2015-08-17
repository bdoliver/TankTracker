#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'tank/watertest/chart/chart.tt2', })
    or die "$Template::ERROR\n";

ok( my $content = $tt->process(), q{processed template ok} );

done_testing();

