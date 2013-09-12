package TankTracker::Route::Login;

use strict;
use warnings;

use Dancer               ':syntax';
use Dancer::Plugin::DBIC 'schema';

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

    my $auth  = auth($login, $pass);

    # Validate the user login
    if ( $login and $pass and authd() ) {
        session logged_in => 1;

        my $user = schema->resultset('TrackerUser')->find({login => $login});

        session user_id => $user->user_id();

        $path = params->{path} || '/journal';
    }
    else {
        set_error("Login failed");

        $path = '/login';
    }

    redirect $path;
};

1;
