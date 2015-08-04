#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'tank/diary/list.tt', })
    or die "$Template::ERROR\n";

my $content;

ok( $content = $tt->process(), q{processed template ok} );

like($content => qr{There are no diary notes in the database for the selected tank.},
    q{no diary notes found}
);

my $diary = [
    {
        diary_id   => 10,
        diary_date => '2015-01-31 15:16:18',
        diary_note => <<_EOT_,
This is note line 1

This is note line 2

_EOT_
   },
];

ok($content = $tt->process({
        diary => $diary,
        pager => { 'last_page' => 1 },
    })
    => q{processed template with diary}
);

like($content => qr{<table class="table table-striped table-hover">},
    q{diary table present}
);

like($content => qr{<td class="text-center">2015-01-31</td>},
    q{formatted diary date}
);

like($content => qr{<td class="text-left">.+?</td>}ms,
    q{diary note present}
);

unlike($content => qr{<a href="/tank/\d+/water_test/view/\d+">\s+</a>},
    q{note is not attached to a water test}
);

$diary->[0]{'test_id'} = 1234;

ok($content = $tt->process({
        tank  => { tank_id => 77 },
        diary => $diary,
        pager => { 'last_page' => 1 },
    })
    => q{processed template with diary + test ID}
);

like($content => qr{<a\s+href="/tank/77/water_test/view/1234">1234</a>}ms,
    q{note is attached to a water test}
);

done_testing();

