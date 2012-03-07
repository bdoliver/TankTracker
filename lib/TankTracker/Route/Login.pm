package TankTracker::Route::Login;

use strict;
use warnings;

use Dancer               ':syntax';

# Although we are using the ::Auth::RBAC::Credentials::DBIC plugin,
# we need to load the core RBAC module to get the auth() method
use Dancer::Plugin::Auth::RBAC;

use TankTracker::Common::Utils qw(set_message
				  get_message
				  set_error
				  get_error);

prefix undef;

get '/login' => sub {
	# Display a login page; the original URL they requested is available as
	# vars->{requested_path}, so put in a hidden field in the form
	template 'login.tt', { 'page_title' => 'Login',
			       'msg'        => get_message(),
			       'err'        => get_error() };
};

post '/login' => sub {
	my $path;

	my $login = params->{login};
	my $pass  = params->{password};

	# Validate the user login
	if ( $login and $pass and auth($login, $pass) ) {
		session logged_in => 1;

		$path = params->{path} || '/journal';
	}
	else {
		set_error("Login failed");

		$path = '/login';
	}

	redirect $path;
};

1;
