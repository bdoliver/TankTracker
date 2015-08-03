#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'user/access/edit.tt2', })
    or die "$Template::ERROR\n";

ok( $tt->process(), q{Processed template ok} );

done_testing();
