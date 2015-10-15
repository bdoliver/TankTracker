package TankTracker::Controller::Root;
use Moose;
use namespace::autoclean;

use Try::Tiny;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu' }

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
        $c->forward('default'); # unknown resource page
        return 0;
    }

    if ( $c->action() eq 'login' or
         $c->action() eq 'reset' or
         $c->action() eq 'signup' ) {
        # auth not required for login/reset/signup pages...
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

sub _reset_form :Private {
    my ( $self, $c ) = @_;

    my $elements = [
        {
            name        => 'reset',
            type        => 'Text',
            constraints => [
                'Printable',
                'Required',
                { type => 'Length', min => 3, max => 50 },
            ],
        },
    ];

    return { 'elements' => $elements };
}

sub reset :Local Args(0) FormMethod('_reset_form') {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{form};

    if ( $form->submitted_and_valid() ) {
        my $reset = $form->param('reset');

        try {
            my $user = $c->model('User')->reset($reset);

            ## FIXME: populate $c->stash->{'email'}
            if ( $user ) {
                $c->forward($c->view('Email'));
                $c->flash->{'reset_ok'} = 1;
                return;
            }

            # Redirect to login, regardless of whether or not
            # we actually reset a user...
            $c->response->redirect($c->uri_for('login'), 302);
            $c->detach();
        }
        catch {
            $c->stash->{'error'} = $_;
        };
    }

    $c->stash->{'page_title'} = 'Account Re-set';
    $c->stash->{'template'}   = 'reset.tt';

    return;
}

sub _signup_form :Private {
    my ( $self, $c ) = @_;

    my $elements = [
        {
            name        => 'email',
            type        => 'Text',
            constraints => [
                'Printable',
                'Required',
                { type => 'Length', min => 3, max => 50 },
            ],
            validators => [ 'TankTracker::EmailExists' ],
        },
    ];

    return { 'elements' => $elements };
}

sub signup :Local Args(0) FormMethod('_signup_form') {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{form};

    if ( $form->submitted_and_valid() ) {
        my $email = $form->param('email');

        try {
            my $signup = $c->model('Signup')->add($email);
use Digest::SHA qw(sha256_base64);
warn "\n\nemail=$email\n",
warn "sha_356=", sha256_base64($email), "\n\n";
            ## FIXME: populate $c->stash->{'signup'}
            if ( $signup ) {
use Data::Dumper;
warn "\n\nSIGNUP:\n", Dumper($signup);
#                 $c->forward($c->view('Email'));
                $c->flash->{'reset_ok'} = 1;
                return;
            }

            # Redirect to login, regardless of whether or not
            # we actually emailed the user...
            $c->response->redirect($c->uri_for('login'), 302);
            $c->detach();
        }
        catch {
            $c->stash->{'error'} = $_;
        };
    }

    $c->stash->{'page_title'} = 'Sign-up for an account';
    $c->stash->{'template'}   = 'signup.tt';

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

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Brendon Oliver <brendon.oliver@gmail.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
