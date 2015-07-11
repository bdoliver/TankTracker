#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Template;

my $tt = Test::Template->new({ INPUT => 'menu.tt2', })
    or die "$Template::ERROR\n";

ok( $tt->process(), q{Processed template ok} );

my $content = $tt->process({ 'active_tab' => q{tank} });

ok($content =~ qr{<li class="active"><a data-toggle="tab" data-target="#tank"}
    => q{'tank' tab active}
);

$content = $tt->process({ 'active_tab' => q{admin} });

ok($content !~ qr{<li class="active"><a data-toggle="tab" data-target="#admin"}
    => q{not admin user, 'admin' tab not active}
);

$content = $tt->process({
    'active_tab' => q{admin},
    'is_admin'   => 1,
});

ok($content =~ qr{<li class="active"><a data-toggle="tab" data-target="#user_admin"}
    => q{is admin user, 'admin' tab is active}
);

done_testing();

