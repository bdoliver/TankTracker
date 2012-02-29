package TankTracker::Logout;

use strict;

use Dancer ':syntax';

use TankTracker::Utils qw(set_message
		          get_message
		          set_error
		          get_error);

prefix undef;

get '/logout' => sub {
	session->destroy;

	set_message('You are logged out.');

	session->destroy;

	redirect "/login";
};

1;
