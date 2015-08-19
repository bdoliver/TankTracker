#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'tank/select.tt', })
    or die "$Template::ERROR\n";

ok( $tt->process(), q{processed template ok} );

done_testing();

