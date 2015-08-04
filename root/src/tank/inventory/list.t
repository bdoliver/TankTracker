#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'tank/inventory/list.tt', })
    or die "$Template::ERROR\n";

my $content;

ok( $content = $tt->process(), q{processed template ok} );

like($content => qr{There are no inventory records in the database for the selected tank.},
    q{no inventory records found}
);

ok($content = $tt->process({
        inventory => [
            {
                inventory_id   => 10,
                inventory_type => 'fuzzywuzzy',
            },
        ],
        pager => { 'last_page' => 1 },
    })
    => q{processed template with inventory}
);

like($content => qr{<td class="text-right">10</td>},
    q{inventory record ID present}
);

like($content => qr{<td class="text-left">Fuzzywuzzy</td>},
    q{formatted inventory type}
);

done_testing();

