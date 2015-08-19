#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'user/access/list.tt', })
    or die "$Template::ERROR\n";

my $content = q{};
ok( $content = $tt->process(), q{Processed template ok} );

like($content => qr{There are no users with tank access in the database},
    q{No access records}
);

subtest 'user by tank' => sub {
    $content = $tt->process({
        list => [
            {
                first_name => 'foo',
                last_name  => 'barbaz',
                access     => [
                    {
                        tank_name  => 'TT #1',
                        water_type => 'brackish',
                        admin      => 0,
                    },
                    {
                        tank_name  => 'TT #2',
                        water_type => 'dryish',
                        admin      => 1,
                    },
                ],
            },
        ],
    });

    like($content => qr{<input type="submit" class="btn btn-primary" value='User / Tank' />},
        q{access records by user/tank}
    );

    like($content => qr{<td class="text-left">foo barbaz</td>},
        q{using 'by_user.tt' template}
    );

    ok((($content =~ qr{<ul\ class="list-unstyled">\s+
                          <li>TT\ #1\ (brackish)</li>}msx) and
        ($content =~ qr{<ul\ class="list-unstyled">\s+
                          <li\ class="text-danger"><strong>No</strong></li>}msx))
        => 'admin not allowed for first-listed tank'
    );
    ok((($content =~ qr{<li>TT\ #2\ (dryish)</li>\s+</ul>}msx) and
        ($content =~ qr{<li\ class="text-success"><strong>Yes</strong></li>\s+</ul>}msx))
        => 'admin allowed for second-listed tank'
    );
};

subtest 'tank by user' => sub {
    $content = $tt->process({
        by_tank => 1,
        list => [
            {
                tank_name  => 'TT #1',
                water_type => 'brackish',
                access     => [
                    {
                        first_name => 'foo',
                        last_name  => 'barbaz',
                        admin      => 0,
                    },
                    {
                        first_name => 'bar',
                        last_name  => 'foobaz',
                        admin      => 1,
                    },
                ],
            },
        ],
    });

    like($content => qr{<input type="submit" class="btn btn-primary" value='Tank / User' />},
        q{access records by tank/user}
    );

    like($content => qr{<td\ class="text-left">TT\ #1\ (brackish)</td>}msx,
        q{using 'by_tank.tt' template}
    );

    ok((($content =~ qr{<ul\ class="list-unstyled">\s+
                          <li>foo\ barbaz</li>}msx) and
        ($content =~ qr{<ul\ class="list-unstyled">\s+
                          <li\ class="text-danger"><strong>No</strong></li>}msx))
        => 'admin not allowed for first-listed user'
    );
    ok((($content =~ qr{<li>bar\ foobaz</li>\s+</ul>}msx) and
        ($content =~ qr{<li\ class="text-success"><strong>Yes</strong></li>\s+</ul>}msx))
        => 'admin allowed for second-listed user'
    );
};

done_testing();

