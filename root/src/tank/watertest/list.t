#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'tank/watertest/list.tt2', })
    or die "$Template::ERROR\n";

my $content;

ok( $content = $tt->process(), q{processed template ok} );

like($content => qr{There are no tests in the database for the selected tank.},
    q{no tests found}
);

my $tank = {
    tank_id => 77,
};

my $tests = [
    {
        test_date => '2015-01-31 15:16:18',
        result_ph => 8.2,
        result_nitrate => 20,
    },
];

subtest 'freshwater tests' => sub {
    ok($content = $tt->process({
        tank  => $tank,
        tests => $tests,
        pager => { 'last_page' => 1 },
    }) => q{template with freshwater test results});

    like($content => qr{<th class="text-center">Test Date</th>},
        q{test table present}
    );
    unlike($content => qr{<th class="text-right">Calcium<br />(Ca)</th>},
        q{saltwater result columns absent}
    );
    like($content => qr{<td class="text-center">2015-01-31</td>},
        q{formatted test date}
    );
    like($content => qr{<td class="text-right">8.20</td>},
        q{formatted ph result}
    );
};

subtest 'saltwater tests' => sub {
    $tank->{'water_type'} = 'salt';
    $tests->[0]{'result_salinity'} = 1.02;

    ok($content = $tt->process({
        tank  => $tank,
        tests => $tests,
        pager => { 'last_page' => 1 },
    }) => q{template with saltwater test results});

    like($content => qr{<th class="text-center">Test Date</th>},
        q{test table present}
    );
    like($content => qr{<th class="text-right">Calcium<br />\(Ca\)</th>},
        q{saltwater result columns present}
    );
    like($content => qr{<td class="text-center">2015-01-31</td>},
        q{formatted test date}
    );
    like($content => qr{<td class="text-right">8.20</td>},
        q{formatted ph result}
    );
    like($content => qr{<td class="text-right">1.020</td>},
        q{formatted salinity result}
    );
};

done_testing();

