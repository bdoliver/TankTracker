package TankTracker;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    StackTrace
    ConfigLoader
    Static::Simple

    Authentication

    Session
    Session::State::Cookie
    Session::Store::DBIC

/;

extends 'Catalyst';

our $VERSION = '0.01';

after 'setup_components' => sub {
    my $app = shift;

    for (keys %{ $app->components }) {
    #warn "*** examining component '$_' for initialise_after_setup()\n";
        $app->components->{$_}->initialise_after_setup($app)
            if $app->components->{$_}->can('initialise_after_setup');
    }
};

# Configure the application.
#
# Note that settings in tanktracker.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'TankTracker',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    default_view => 'HTML',
    uploadtmp => '/tmp/tt_uploads',

    photo_root => '/static/images/photos',

    'View::HTML' => {
        # set the location for TT files
        INCLUDE_PATH => [
            __PACKAGE__->path_to('root', 'lib'),
            __PACKAGE__->path_to('root', 'src'),
        ],
        PRE_PROCESS => 'macro.tt',
        WRAPPER     => 'content.tt',
        PRE_CHOMP   => 1,
        ERROR       => $ENV{'CATALYST_DEBUG'}
                       ? undef
                       : 'error/template_error.tt',
    },

    'View::JSON' => {
        allow_callback => 0,
        expose_stash   => 'chart_data',
    },

    'Plugin::Authentication' => {
        'default_realm' => 'tt_users',
        'realms'        => {
            'tt_users' => {
                'credential' => {
                    'class'          => 'Password',
                    'password_field' => 'password',
                    'password_type'  => 'self_check',
                },
                'store' => {
                    'class'         => 'DBIx::Class',
                    'user_model'    => 'User',
                },
            },
        },
    },

    'Plugin::Session' => {
        dbic_class => 'TankTracker::Session',
        expires    => 3600,
        id_field   => 'session_id',
    },

    'Controller::HTML::FormFu' => {
        config_callback => 0,
        default_action_use_path => 1,
        constructor => {
            default_args => {
                elements => {
                    Field => {
                        layout => [ 'field' ],
                        attributes => { class => 'form-control' },
                    },
                    Checkbox => {
                        # I don't like the way bootstrap renders checkboxes,
                        # so override the class:
                        attributes => { class => 'none' },
                    },
                    Radiogroup => {
                        attributes => { class => 'radio' },
                        container_attributes => { class => 'form-group' },
                    },
                    Submit => {
                        attributes => { class => 'form-control btn btn-primary' },
                    },
                    DateTime => {
                        deflators => {
                            type => 'Strftime',
                            strftime => '%Y-%m-%d',
                        },
                        inflators => {
                            type => 'DateTime',
                            parser => { strptime => '%Y-%m-%d' },
                        },
                    },
                },
            },
        },
    },
);

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

TankTracker - Catalyst based application

=head1 SYNOPSIS

    script/tanktracker_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<TankTracker::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Brendon Oliver <brendon.oliver@gmail.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
