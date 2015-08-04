#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'tank/watertest/list.tt', })
    or die "$Template::ERROR\n";

my $content;

ok( $content = $tt->process(), q{processed template ok} );

like($content => qr{There are no tests in the database for the selected tank.},
    q{no tests found}
);

ok($content = $tt->process({
    tank         => { tank_id => 77 },
    col_headings => [
        {
            active    => 1,
            col_align => 'center',
            title     => 'My Title',
            label     => 'myLabel',
        },
    ],
    tests        => [
        {
            test_id   => 9875,
            test_date => '2015-01-31 15:16:18',
            water_test_results => [
                {
                    parameter   => 'ph',
                    test_result => 8.2,
                },
                {
                    parameter   => 'salinity',
                    test_result => 1.020,
                },
            ],
            diaries   => [
                {
                    diary_date => '2015-01-31 15:16:18',
                    diary_note => 'this is a note',
                },
            ],
        },

    ],
    pager        => { 'last_page' => 1 },
}) => q{template with test results});

subtest 'column heading formatting' => sub {
    like($content => qr{<th class="text-center">},
        q{column alignment}
    );
    like($content => qr{My<br />Title},
        q{wrapped column heading}
    );
    like($content => qr{<br />myLabel},
        q{column label}
    );
};

subtest 'data formatting' => sub {
    like($content => qr{<a href="/tank/77/water_test/9875/edit"},
        q{edit test URL}
    );
    like($content => qr{<td\ class="text-center">2015-01-31\s+</td>}msx,
        q{test date}
    );
    like($content => qr{<td\ class="text-right">8.20\s+</td>}msx,
        q{ph result}
    );
    like($content => qr{<td\ class="text-right">1.020\s+</td>}msx,
        q{salinity result}
    );
    like($content => qr{data-title="Notes for test #9875},
        q{test note heading}
    );
    like($content => qr{<dt>2015-01-31\s+15:16:18</dt>\s+
                        <dd>\Qthis is a note\E</dd>}msx,
        q{test note content}
    );
};

done_testing();

