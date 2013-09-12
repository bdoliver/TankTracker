package TankTracker::Route::Logout;

use strict;
use warnings;

use Dancer ':syntax';

use TankTracker::Common::Utils qw(set_message
				  get_message
				  set_error
				  get_error);

prefix undef;

get '/logout' => sub {
    session->destroy;

    set_message('You are logged out.');

    session->destroy;  ## 2nd call should _not_ be necessary!

    redirect "/login";
};

1;
