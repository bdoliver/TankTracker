package TankTracker::Controller::Root;
use Moose;
use namespace::autoclean;

use Try::Tiny;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu' }
with 'Catalyst::TraitFor::Controller::reCAPTCHA::V2';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

TankTracker::Controller::Root - Root Controller for TankTracker

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 auto

Check if there is a user and, if not, forward to login page

=cut

# Note that 'auto' runs after 'begin' but before your actions and that
# 'auto's "chain" (all from application path to most specific class are run)
# See the 'Actions' section of 'Catalyst::Manual::Intro' for more info.
sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{'template_wrappers'} = [ 'html.tt' ];

    $c->forward('check_request') || return 0;

    # User found, so everything ok - continue processing
    return 1;
}

sub check_request : Private {
    my ( $self, $c ) = @_;

    # block form submission with a GET request (a potential XSS attack)
    if ( $c->request->method() eq 'GET'          &&
         scalar %{ $c->request->query_params() }
    ) {
        # password_(update|reset) are the only action permissible
        # with GET parameters.  Necessary because the
        # code is provided as a link in an email...
        if ( $c->action !~ qr{^password_(?:update|reset)$} ) {
            $c->forward('default'); # unknown resource page
            return 0;
        }
    }

    my %permitted_actions = (
        'login'            => 1,
        'password_reset'   => 1,
        'signup'           => 1,
    );

    # authorisation not required for permitted actions...
    if ( exists $permitted_actions{ $c->action() } ) {
        return 1;
    }

    # unauthenticated request - force login...
    if ( ! $c->user_exists() ) {
        $c->response->redirect($c->uri_for('login'));
        return 0;
    }

    $c->response->headers->header(
        'Cache-control' => 'must-revalidate, private, no-store, max-age=0, no-cache'
    );
    $c->response->headers->header('Pragma' => 'no-cache');

    $c->stash->{'user'} = $c->model('User')->get($c->user->user_id());

    push @{ $c->stash->{'template_wrappers'} }, 'menu.tt';

    $c->stash->{'is_admin'} = ( $c->user->role() eq 'admin' );

    return 1;
}

sub _login_form :Private {
    my ( $self, $c ) = @_;

    my $elements = [
        {
            name        => 'username',
            type        => 'Text',
            constraints => [
                'Printable',
                'Required',
                { type => 'Length', min => 3, max => 50 },
            ],
        },
        {
            name        => 'password',
            type        => 'Password',
            constraints => [
                'Printable',
                'Required',
                { type => 'Length', min => 3, max => 50 },
            ],
        },
        {
            type => 'Submit',
            name => 'submit',
        },
    ];

    return { 'elements' => $elements };
}

sub login : Local Args(0) FormMethod('_login_form') {
    my ( $self, $c ) = @_;

    if ( $c->user_exists() ) {
        $c->response->redirect($c->uri_for('tank'), 302);
        $c->detach();
        return;
    }

    $c->stash->{'signup_ok'} ||= $c->flash->{'signup_ok'};
    $c->stash->{'reset_ok'}  ||= $c->flash->{'reset_ok'};

    my $form = $c->stash->{form};

    if ( $form->submitted_and_valid() ) {

        my $username = $form->param('username');
        my $password = $form->param('password');

        # If the username and password values were found in form
        if ( $username and $password ) {
            # Attempt to log the user in: allow use of email
            # to login too...
            if ( $c->authenticate({
                    'password'   => $password,
                    'dbix_class' => {
                        'searchargs' => [
                            {
                                '-or' => [
                                    username => $username,
                                    email    => $username,
                                ],
                            },
                            {
                                'prefetch' => [
                                    'user_preference',
                                    'tank_user_accesses',
                                ],
                            },
                        ],
                    },
              }) ) {

                if ( $c->model('User')->is_password_expired(
                        $c->user->user_id(),
                        $c->config->{'password_expires_days'},
                    ) ) {
                    $c->log->warn("detected expired password for user=$username");
                    if ( my $user = $c->model('User')->request_password_reset(
                        { user_id => $c->user->user_id() }
                       ) ) {
                        $c->delete_session();
                        $c->response->redirect($c->uri_for("/password_reset?code=$user->{reset_code}"), 302);
                        $c->detach();
                        return;
                    }
                    else {
                        $c->log->error(q{Failed to generate expired password reset code});
                    }
                }

                try {
                    $c->model('User')->record_last_login(
                        $c->user->user_id(),
                        $c->config->{'max_login_attempts'},
                    );
                }
                catch {
                    $c->stash->{'error'} = $_;
                };

                if ( not $c->stash->{'error'} ) {
                    $c->response->redirect($c->uri_for('/tank'), 302);
                    $c->detach();
                    return;
                }
            } else {
                ## speculatively update failed attempt count...
                $c->model('User')->update_login_attempts($username);
                $c->stash->{'error'} = q{Bad username or password.};
            }
        } else {
            $c->stash->{'error'} = q{Empty username or password.}
                unless ($c->user_exists);
        }
    }

    $c->stash->{'reset_link'} = $c->uri_for('/reset');
    $c->stash->{'page_title'} = 'Login';
    $c->stash->{'template'}   = 'login.tt';

    return;
}

sub logout :Local Args(0) {
    my ( $self, $c ) = @_;

    $c->delete_session();

    # setting flash should recreate the session
    $c->stash->{'logout_message'} = 'You have logged out.';
    $c->response->redirect($c->uri_for('login'), 302);
    return;
}

sub _password_reset_form {
    my ( $self, $c ) = @_;

    my $reset_code;

    if ( $c->request->method() eq 'GET' ) {
        # reset request code only via GET.
        $reset_code = $c->request->query_parameters->{'code'};
    }
    else {
        $reset_code = $c->request->body_parameters->{'reset_code'};
    }

    my @elements;

    if ( $reset_code ) {
        @elements = (
            {
                name  => 'reset_code',
                type  => 'Hidden',
                value => $reset_code,
            },
            {
                name        => 'check_password_1',
                type        => 'Password',
                constraints => [
                    'Printable',
                    {
                        type => 'Length',
                        min  => 8,
                        max => 50,
                    },
                    {
                        type    => 'Required',
                        message => 'New password is required'
                    },
                ],
                validators => [
                    'TankTracker::ValidPassword',
                ],
            },
            {
                name        => 'check_password_2',
                type        => 'Password',
                constraints => [
                    'Printable',
                    {
                        type => 'Length',
                        min  => 8,
                        max => 50,
                    },
                    {
                        type    => 'Required',
                        message => 'Confirm password is required'
                    },
                    {
                        type => 'Callback',
                        callback => sub {
                            my ( $value, $params ) = @_;

                            return 1 if ( ! $value and ! $params->{'check_password_1'} );
                            return ( $value and $params->{'check_password_1'}
                                    and
                                    ( $value eq $params->{'check_password_1'} ) );
                        },
                        message => 'New passwords do not match',
                    },
                ],
            },
        );
    }
    else {
        @elements = (
            {
                name        => 'username',
                type        => 'Text',
                constraints => [
                    'Printable',
                    'Required',
                ],
            },
        );
    }

    push @elements,
        {
            type => 'Submit',
            name => 'submit',
        };

    return {
        'elements' => \@elements,
    };
}

sub password_reset :Local FormMethod('_password_reset_form') {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{form};

    if ( $form->submitted_and_valid() ) {
        try {
            if ( my $username = $form->param('username') ) {
                # request a reset code be sent to the user
                my $user = $c->model('User')->request_password_reset(
                    {
                        '-or' => {
                            username => $username,
                            email    => $username,
                        },
                    },
                );

                if ( $user ) {
                    my $email = {
                        from         => 'admin@tanktracker.caboo.isa-geek.net',
                        to           => $user->{'email'},
                        subject      => 'TankTracker - password reset request',
                        templates    => [
                            {
                                template        => 'password_reset_html.tt',
                                content_type    => 'text/html',
                                charset         => 'utf-8',
                                encoding        => 'quoted-printable',
                            },
                            {
                                template        => 'password_reset_text.tt',
                                content_type    => 'text/plain',
                                charset         => 'utf-8',
                            },
                        ],
                        content_type => 'multipart/alternative',
                    };
                    $c->stash->{'email'} = $email;
                    $c->stash->{'code'}  = $user->{'reset_code'};
                    $c->forward($c->view('Email::HTML'));
                    $c->flash->{'reset_ok'} = 1;
                }
                else {
                    # log the fact that there was no such user:
                    $c->log->warn("Attempt to reset password for non-existant user '$username'");
                }
            }
            else {
                # user is trying to reset their password:
                my $args = {
                    reset_code => $form->param('reset_code'),
                    password   => $form->param('check_password_1'),
                };
                my $user = $c->model('User')->reset_password($args);
                $c->flash->{'update_ok'} = 1;
            }
        }
        catch {
            $c->stash->{'error'} = $_;
        };

        # Redirect to login, regardless of whether or not
        # we actually reset a user...
        $c->response->redirect($c->uri_for('login'), 302);
        $c->detach();
        return;
    }

    $c->stash->{'page_title'} = 'Account Re-set';
    $c->stash->{'template'}   = 'password_reset.tt';

    return;
}

sub _signup_form :Private {
    my ( $self, $c ) = @_;

    my $elements = [
        {
            name        => 'username',
            type        => 'Text',
            constraints => [
                {
                    type => 'Required',
                    message => 'You must enter a user name for your account',
                },
                {
                    type => 'Length',
                    message => 'Your user name must be between 4 and 20 characters long',
                    min  => 4,
                    max  => 20,
                },
            ],
            validators => [
                'TankTracker::UserExists',
            ],
        },
        {
            name        => 'email',
            type        => 'Text',
            constraints => [
                {
                    type => 'Required',
                    message => 'You must enter an email address',
                },
            ],
            validators => [
                'TankTracker::ValidEmail',
                'TankTracker::EmailExists',
            ],
        },
        {
            type => 'Submit',
            name => 'submit',
        },
    ];

    return { 'elements' => $elements };
}

sub signup :Local Args(0) FormMethod('_signup_form') {
    my ( $self, $c ) = @_;

    ## invert the 'skip_recaptcha' config setting:
    my $want_recaptcha = ( $c->config->{'skip_recaptcha'} || 0 ) ? 0 : 1;

    my $form = $c->stash->{form};

    if ( $form->submitted_and_valid() ) {

        try {
            # check reCAPTCHA result:
            if ( $want_recaptcha ) {
                if ( not $c->forward('captcha_check') ) {
                    my $err = $c->stash->{recaptcha_error}."\n";
                     $err ||= "reCAPTCHA verification failed\n";
                    die $err;
                }
            }

            my $username = $form->param('username');
            my $email    = $form->param('email');

            # sanity check
            ( $username and $email ) or
                die "Signup requires both user name and email address\n";

            if ( my $reset_code = $c->model('User')->signup({
                username => $username,
                email    => $email
            })) {

                my $email = {
                    from         => 'admin@tanktracker.caboo.isa-geek.net',
                    to           => $email,
                    subject      => 'Welcome to TankTracker',
                    templates    => [
                        {
                            template        => 'welcome_html.tt',
                            content_type    => 'text/html',
                            charset         => 'utf-8',
                            encoding        => 'quoted-printable',
                        },
                        {
                            template        => 'welcome_text.tt',
                            content_type    => 'text/plain',
                            charset         => 'utf-8',
                        }
                    ],
                    content_type => 'multipart/alternative',
                };
                $c->stash->{'email'} = $email;
                $c->stash->{'code'}  = $reset_code;
                $c->forward($c->view('Email::HTML'));
                $c->flash->{'signup_ok'} = 1;
            }

            # Redirect to login, regardless of whether or not
            # we actually emailed the user...
            $c->response->redirect($c->uri_for('login'), 302);
            $c->detach();
            return;
        }
        catch {
            my $err;

            if ( $c->error ) {
                $err = ref($c->error) eq 'ARRAY'
                       ? join("\n", @{ $c->error } )
                       : $c->error;
            }

            $err ||= $_;

            $c->stash->{'error'} = $err;
        };
    }

    if ( $want_recaptcha ) {
        $c->forward('captcha_get');
    }

    $c->stash->{'page_title'}        = 'Sign-up for an account';
    $c->stash->{'template'}          = 'signup.tt';

    return;
}

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->status(302);
    $c->response->redirect($c->uri_for('login'));

    return;
}

=head2 default

Standard 404 error page

=cut

sub default :Local {
    my ( $self, $c ) = @_;

    $c->stash->{'template'} = 'error.tt';
    $c->stash->{'error'}  ||= $c->flash->{'error'};

    if ( not $c->stash->{'error'} ) {
        $c->stash->{'error'} = 'Requested resource is unavailable';
        $c->response->status(404);
    }
    else {
        $c->response->status(403);
    }
}

=head2 end

Attempt to render a view, if needed.

=cut

# sub end : ActionClass('RenderView') {}
## Security-related headers. Refer:
## http://perltricks.com/article/84/2014/4/28/Is-your-login-page-secure-
## https://github.com/dnmfarrell/SecApp_login/blob/master/lib/SecApp/Controller/Root.pm#L90
sub end : ActionClass('RenderView') {
    my ($self, $c) = @_;

    # NB: these headers will prevent reCAPTCHA from working, but on
    #     the pages where they are used, we can safely ignore them:
    if ( not $c->stash->{'recaptcha'} ) {
        $c->response->header(
            'X-Frame-Options'           => q{DENY},
            'Content-Security-Policy'   => q{default-src 'self' http://www.google.com https://www.google.com 'unsafe-eval' 'unsafe-inline'},
            'X-Content-Type-Options'    => q{nosniff},
            'X-Download-Options'        => q{noopen},
            'X-XSS-Protection'          => q{1; 'mode=block'},
        );
    }
}

=head1 AUTHOR

Brendon Oliver <brendon.oliver@gmail.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
