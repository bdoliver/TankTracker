#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'tank/details.tt', })
    or die "$Template::ERROR\n";

my $content;

ok( $content = $tt->process(), q{processed template ok} );

# subtest q{Tank 'edit' mode} => sub {
#     unlike($content => qr{href="/tank/\d+/edit"},
#         q{link to edit tank details absent}
#     );
# };
# 
# subtest q{Tank 'view' mode} => sub {
#     $content = $tt->process({
#         tank_action => 'view',
#         tank => {
#             tank_id => 99,
#             tank_name => 'Foo',
#         },
#     } => q{processed template for 'view' mode});
# 
#     like($content => qr{<td class="details">Foo</td>},
#         q{tank name present}
#     );
#     like($content => qr{href="/tank/99/edit"},
#         q{link to edit tank details present}
#     );
# };

done_testing();

