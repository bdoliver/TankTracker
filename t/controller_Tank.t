use strict;
use warnings;
use Test::More;


use Catalyst::Test 'TankTracker';
use TankTracker::Controller::Tank;

ok( request('/tank')->is_success, 'Request should succeed' );
done_testing();
