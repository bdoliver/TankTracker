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
use TankTracker::Route::Inventory;

use TankTracker::Common::User  qw(do_login);
use TankTracker::Common::Theme qw(theme_list DEFAULT_THEME);

hook before_template => sub {
    my $tokens = shift;

    # Plug some useful values into all templates
    $tokens->{'sessId'}   = session->{'id'};
    $tokens->{'user_id'}  = session->{'user_id'};
    $tokens->{'jq_theme'} = params->{'jq_theme'}
                            || session->{'jq_theme'}
                            || config->{default_theme}
                            || DEFAULT_THEME;
    $tokens->{'themes'}   = theme_list($tokens->{'jq_theme'});  
};

# make sure user is logged in
hook before => sub {
    ## shenanigans to sort out the jqueryUI theme
    if ( params->{jq_theme} ) {
        # requested:
        session jq_theme => params->{jq_theme};
        cookie  jq_theme => params->{jq_theme};
    }
    else {
        my $theme = cookie 'jq_theme';

        if ( $theme ) {
            # set from cookie
            session jq_theme => $theme;
        }
        else {
            # default
            cookie jq_theme => DEFAULT_THEME;
        }
    }

    my $path = '/login';

    if ( ! session('logged_in') and
         request->path_info !~ m|^/login| ) {
        if ( params->{login} and params->{password} ) {
            # try to login with credentials passed in the request
            my %params = params;
               $params{path} = request->path_info;

            $path = do_login(\%params);
        }

        return redirect $path;
    }
};

# Default path = journal page
any ['get', 'post'] => '/' => sub { redirect '/journal'; };

1;
