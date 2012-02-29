package TankTracker;

use strict;

use Dancer ':syntax';

## Route handlers:
use TankTracker::Diary;
use TankTracker::Journal;
use TankTracker::Login;
use TankTracker::Logout;
use TankTracker::Tank;
use TankTracker::WaterTest;

hook before_template => sub {
	my $tokens = shift;

	# Plug the session ID into the template in case we need it
	$tokens->{'sessId'} = session('id');
};

# make sure user is logged in
hook before => sub {
	return redirect '/login' if ( ! session('logged_in') and 
				      request->path_info !~ m|^/login| );
};

# Default path = journal page
any ['get', 'post'] => '/' => sub { redirect '/journal'; };

1;
