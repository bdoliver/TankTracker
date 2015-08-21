#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Test::WWW::Mechanize::Catalyst;

my $ua = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'TankTracker');

$ua->get_ok('/');
$ua->title_is('TankTracker - Login');

$ua->submit_form_ok(
    {
        fields => {
            username => 'bdo',
            password => 'test123',
        },
        button => 'submit',
    }
    => 'Logged in'
     );
$ua->title_is('TankTracker - Tank');

$ua->get_ok('/admin/parameters');
warn "\nCONTENT:\n", $ua->content(), "\n\n";
# $ua->content_like(qr{<li\ class="active">
#                      <a\ data-toggle="tab"\ data-target="\#tank">Tank</a>
#                      </li>}msx
#     => 'Menu active tab = Tank'
# );
# ok( request('/login')->is_success, 'Login page' );

done_testing();
