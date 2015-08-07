package TankTracker::Controller::User::Details;
use Moose;
use namespace::autoclean;

use Try::Tiny;

BEGIN { extends q{Catalyst::Controller::HTML::FormFu} }

with q{TankTracker::TraitFor::Controller::User};

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{'page_title'} = 'User';
    $c->stash->{'active_tab'} = 'user';

    return 1;
}

sub _details :Private {
    my ( $self, $c ) = @_;

    my $add_user = $c->stash->{'action_heading'} eq 'Add' ? 1 : 0;
    my $elements = [];

    my $edit_username = 1;

    # Can't allow the currently logged-in user to edit their
    # own username as it will screw up session handling.
    if ( exists $c->stash->{'user'}             and
         exists $c->stash->{'user'}{'username'} and
         $c->stash->{'user'}{'username'} eq $c->user->username() ) {
        $edit_username = 0;
    }

    if ( $edit_username ) {
        push @$elements, {
            name => 'username',
            type => 'Text',
            constraints => [
                {
                    type    => 'Required',
                    message => 'Login username cannot be blank',
                },
                {
                    type    => 'Printable',
                    message => 'Login username may only contain printable characters',
                },
            ],
            validators => [ 'TankTracker::UserExists' ],
        };
    }

    push @$elements,
        {
            name => 'first_name',
            type => 'Text',
            constraints => [
                {
                    type    => 'Printable',
                    message => 'First name may only contain printable characters',
                },
            ],
        },
        {
            name => 'last_name',
            type => 'Text',
            constraints => [
                {
                    type    => 'Printable',
                    message => 'Last name may only contain printable characters',
                },
            ],
        },
        {
            name => 'email',
            type => 'Email',
            constraints => [
                {
                    type    => 'Required',
                    message => 'Email address cannot be blank',
                },
                {
                    type => 'Email',
                    message => 'Email must contain a valid email address',
                }
            ],
            validators => [ 'TankTracker::EmailExists' ],
        };

    if ( not $add_user ) {
        push @$elements,
            {
                name => 'change_password',
                type => 'Checkbox',
            },
            {
                name => 'current_password',
                type => 'Password',
                constraints => [
                    {
                        type => 'Required',
                        when => { field => 'change_password' },
                        message => 'Current password is required',
                    },
                ],
            };
    }

    my @password_fields = (
        {
            name => 'new_password1',
            type => 'Password',
            constraints => [
                {
                    type => 'Required',
                    message => 'New password is required',
                },
                {
                    type    => 'Printable',
                    message => 'New password may only contain printable characters',
                },
                {
                    type    => 'MinLength',
                    min     => 8,
                    message => 'Password must be at least 8 characters long',
                },
                {
                    type    => 'MaxLength',
                    max     => 20,
                    message => 'Password must be no more than 20 characters long',
                },
            ],
        },
        {
            name => 'new_password2',
            type => 'Password',
            constraints => [
                {
                    type => 'Required',
                    message => 'Confirm password is required',
                },
                {
                    type => 'Callback',
                    callback => sub {
                        my ( $value, $params ) = @_;

                        return 1 if ( ! $value and ! $params->{'new_password1'} );
                        return ( $value and $params->{'new_password1'}
                                 and
                                 ( $value eq $params->{'new_password1'} ) );
                    },
                    message => 'New passwords do not match',
                },
            ],
        }
    );

    if ( not $add_user ) {
        # need to set constraint 'when' attributes on password fields
        # (these aren't necessary when adding a new user):
        my $when = { field => 'change_password' };
        $password_fields[0]{'constraints'}[0]{'when'} = $when;
        $password_fields[1]{'constraints'}[0]{'when'} = $when;
        $password_fields[1]{'constraints'}[1]{'when'} = $when;
    }

    push @$elements,
        @password_fields,
        {
            name  => 'dimension_units',
            type  => 'Select',
            empty_first       => 1,
            empty_first_label => '- Units -',
            options => [
                [ 'mm'     => 'mm'     ],
                [ 'cm'     => 'cm'     ],
                [ 'm'      => 'm'      ],
                [ 'inches' => 'inches' ],
                [ 'feet'   => 'feet'   ],
            ],
            constraints => [
                {
                    type    => 'Required',
                    message => 'You must select the units for the dimensions of your tank(s)',
                },
            ],
        },
        {
            name  => 'capacity_units',
            type  => 'Select',
            empty_first       => 1,
            empty_first_label => '- Units -',
            options => [
                [ 'litres'     => 'Litres'     ],
                [ 'gallons'    => 'Gallons'    ],
                [ 'us gallons' => 'US Gallons' ],
            ],
            constraints => [
                {
                    type    => 'Required',
                    message => 'You must select the units for the capacity of your tank(s)',
                },
            ],
        },
        {
            name  => 'temperature_scale',
            type  => 'Select',
            empty_first       => 1,
            empty_first_label => '- Units -',
            options => [
                [ 'C' => 'Celsius'    ],
                [ 'F' => 'Fahrenheit' ],
            ],
            constraints => [
                {
                    type    => 'Required',
                    message => 'You must select the temperature scale for your tank(s) water tests',
                },
            ],
        },
        {
            name => 'recs_per_page',
            type => 'Text',
            constraints => [
                {
                    type    => 'Number',
                    message => 'Records per page must be a number',
                },
                {
                    type    => 'Range',
                    min     => 5,
                    max     => 50,
                    message => 'Records per page must be between 5 and 50',
                },
            ],
        };

    return { elements => $elements };
}

## We need to do this before add() is called, otherwise the stashed user
## will still be present when the form method is called to construct the
## form.
before add => sub {
    my ( $self, $c ) = @_;

    delete $c->stash->{'user'};
};

sub add : Chained('base') :PathPart('add') Args(0) {
    my ( $self, $c ) = @_;

    # Add is only ever called from the 'Admin' tab:
    $c->stash->{'active_tab'}     = 'admin';
    $c->stash->{'action_heading'} = 'Add';

    $c->forward('details');

    delete $c->stash->{'user'};

    return;
}

sub edit : Chained('get_user') :PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'tank_action'}    = 'edit';
    $c->stash->{'action_heading'} = 'Edit';

    $c->forward('details');

    return;
}

## FIXME: do we really need this one?
sub view : Chained('get_user') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'tank_action'}    = 'view';
    $c->stash->{'action_heading'} = 'Details';

    $c->forward('details');
}

sub details :Args(0) FormMethod('_details') {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $params = $form->params();

        delete $params->{'submit'};

        # need to split preferences from user attributes
        my $prefs = {};

        for my $pref ( qw(capacity_units
                          dimension_units
                          temperature_scale
                          recs_per_page) ) {
            $prefs->{$pref} = delete $params->{$pref};
        }

        # ensure default...
        $prefs->{'recs_per_page'} ||= 10;

        if ( $c->stash->{'action_heading'} eq 'Add' ) {
            # set the parent user when adding a new user
            $params->{'parent_id'} = $c->user->user_id();
        }

        try {
            $c->model('User')->update(
                $c->stash->{'user'}{'user_id'}, $params, $prefs
            );
            $c->stash->{'message'} = q{Updated user details.};
        }
        catch {
            my $error = qq{Error saving user details: $_};
            $c->log->error($error);
            $c->stash->{'error'} = $error;
            $c->detach();
            return;
        };

        # return to the Admin user list after successful add:
        if ( $c->stash->{'action_heading'} eq 'Add' ) {
            $c->response->redirect($c->uri_for('/user/admin'));
            $c->detach();
            return;
        }
    }

    if ( not $form->submitted() ) {
       my $defaults = {};

        if ( $c->stash->{'action_heading'} eq 'Add' ) {
            $defaults = { 'recs_per_page' => 10 };
        }
        else {
            my $prefs = delete $c->stash->{'edit_user'}{'preferences'};
            $defaults = {
                %{ $c->stash->{'edit_user'} },
                %{ $prefs },
            };
        }

        $form->default_values($defaults);
    }

    $c->stash->{'action_heading'} = 'Details';
    $c->stash->{'template'} = 'user/details.tt2';

    return;
}

sub list :Path('/user/admin/') {
    my ( $self, $c, $page, $column, $direction ) = @_;

    $page      ||= 1;
    $column    ||= 'username',
    $direction ||= 'asc';

    my ( $users, $pager ) = @{ $c->model('User')->list(
        undef,
        {
            order_by => { "-$direction" => $column },
            page     => $page,
            rows     => $c->stash->{'user'}{'preferences'}{'recs_per_page'} || 10,
        },
    ) };

    if ( $pager and ref($pager) ) {
        $pager->{'what'}      = 'users';
        $pager->{'path'}      = [ '/user', 'admin', $page ];
        $pager->{'column'}    = $column;
        $pager->{'direction'} = $direction;
    }

    $c->stash->{'users'} = $users;
    $c->stash->{'pager'} = $pager;

    $c->stash->{'page_title'}     = 'User Admin';
    $c->stash->{'action_heading'} = 'List users';
    $c->stash->{'active_tab'}     = 'admin';
    $c->stash->{'add_url'}        = q{/user/add};

    $c->stash->{'template'}       = 'user/list.tt2';

    return;
}

__PACKAGE__->meta->make_immutable;

1;
