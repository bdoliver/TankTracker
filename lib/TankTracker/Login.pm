package TankTracker::Login;

use strict;

use Dancer ':syntax';

use TankTracker::Utils qw(set_message
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

	# Validate the username and password they supplied
	if (params->{username} and 
	    params->{password} and
	    params->{username} eq setting('username') and
	    params->{password} eq setting('password') ) {
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