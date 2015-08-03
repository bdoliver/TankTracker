#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'user/access/list/by_user.tt2', })
    or die "$Template::ERROR\n";

ok( $tt->process(), q{Processed template ok} );

## We don't need any further tests as the template is exercised via
## the user/access/list.t test.

done_testing();

