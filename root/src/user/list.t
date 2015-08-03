#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'user/list.tt2', })
    or die "$Template::ERROR\n";

ok( $tt->process(), q{Processed template ok} );

## No need for additional tests. Just make sure we have good HTML.

done_testing();

