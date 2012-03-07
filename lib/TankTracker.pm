package TankTracker;

use strict;
use warnings;

use Dancer ':syntax';

## Route handlers:
use TankTracker::Route::Diary;
use TankTracker::Route::Journal;
use TankTracker::Route::Login;
use TankTracker::Route::Logout;
use TankTracker::Route::Tank;
use TankTracker::Route::WaterTest;

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
