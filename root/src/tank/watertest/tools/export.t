#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'tank/watertest/tools/export.tt2', })
    or die "$Template::ERROR\n";

my $content;

ok( $content = $tt->process(), q{processed template ok} );

done_testing();

