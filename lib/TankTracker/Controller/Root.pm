package TankTracker::Controller::Root;
use Moose;
use namespace::autoclean;

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

    # User found, so everything ok - continue procesing
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

    if ( $c->action() eq 'login' ) {
        # auth not required for login page...
        return 1;
    }

     # unauthenticated request - force login...
    if ( ! $c->user_exists() ) {
        $c->response->redirect($c->uri_for('login'));
        return 0;
    }

    $c->response->headers->header(
        'Cache-control' => 'no-cache, must-revalidate, private, no-store'
    );
    $c->response->headers->header('Pragma' => 'no-cache');

    $c->stash->{'user'} = $c->model('User')->get($c->user->user_id());

    push @{ $c->stash->{'template_wrappers'} }, 'menu.tt';

    if ( $c->user->has_role('Admin') ) {
        $c->stash->{'is_admin'} = 1;
    }

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

sub login : Local FormMethod('_login_form') Args(0) {
    my ( $self, $c, @args ) = @_;

    if ( $c->user_exists() ) {
        $c->response->redirect($c->uri_for('tank'));
        $c->detach();
        return;
    }

    my $form = $c->stash->{form};

    if ( $form->submitted_and_valid() ) {

        my $username = $c->request->params->{'username'};
        my $password = $c->request->params->{'password'};

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
                                    {
                                        'tracker_user_roles' => 'role'
                                    },
                                    'tank_user_accesses',
                                ],
                            },
                        ],
                    },
              }) ) {
                $c->model('User')->record_last_login($c->user->user_id());
                $c->response->redirect($c->uri_for('/menu'));
                $c->detach();
                return;
            } else {
                $c->stash(error => q{Bad username or password.});
            }
        } else {
            $c->stash(error => q{Empty username or password.})
                unless ($c->user_exists);
        }
    }

    $c->stash->{'page_title'} = 'Login';
    $c->stash->{'template'}   = 'login.tt';

    return;
}

sub logout :Local Args(0) {
    my ( $self, $c ) = @_;

    $c->delete_session();

    # setting flash should recreate the session
    $c->stash->{'logout_message'} = 'You have logged out.';
    $c->response->redirect($c->uri_for('login'),302);
    return;

}

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->redirect($c->uri_for('login'));

    return;
}

sub menu :Path :Args(0) {
    my ( $self, $c ) = @_;

    return;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    #$c->response->body( 'Page not found' );
    $c->stash->{'template'} = 'error.tt';
    $c->stash->{'error'}  ||= 'Requested resource is unavailable';
    $c->response->status(404);
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
