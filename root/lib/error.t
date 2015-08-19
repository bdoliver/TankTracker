#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'error.t', })
    or die "$Template::ERROR\n";

ok( $tt->process(), q{Processed template ok} );

done_testing();

