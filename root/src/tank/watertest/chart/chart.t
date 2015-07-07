#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'tank/watertest/chart/chart.tt2', })
    or die "$Template::ERROR\n";

my $content;

ok( $content = $tt->process(), q{processed template ok} );

unlike($content => qr{<label class="checkbox-inline" for="result_calcium">},
    q{freshwater tank: saltwater result options absent}
);

ok($content = $tt->process({ tank => { water_type => 'salt' } })
    => q{processed template for saltwater tank}
);

like($content => qr{<label class="checkbox-inline" for="result_calcium">},
    q{saltwater tank: saltwater result options present}
);

done_testing();

