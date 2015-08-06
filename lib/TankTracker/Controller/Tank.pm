package TankTracker::Controller::Tank;
use Moose;
use namespace::autoclean;

use Try::Tiny;

BEGIN { extends q{Catalyst::Controller::HTML::FormFu} }

with q{TankTracker::TraitFor::Controller::Tank};

=head1 NAME

TankTracker::Controller::Tank - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{'page_title'} = 'Tank';
    $c->stash->{'active_tab'} = 'tank';

    return 1;
}

sub _select_form :Private {
    my ( $self, $c ) = @_;

    my @tanks = @{ $c->model('UserTank')->list(
        {
            user_id => $c->user->user_id(),
        },
        {
            order_by => { -asc => 'tank_name' },
        },
    ) };

    my @elements = ();

    if ( @tanks ) {
        push @elements,
        {
            name    => 'tank_id',
            type    => 'Select',
            options => [
                map { [
                      $_->{'tank_id'} => sprintf('%s (%s)',
                                                 $_->{'tank_name'},
                                                 $_->{'water_type'})
                ] } @tanks
            ],
            empty_first       => 1,
            empty_first_label => '- Select Tank -',
            default           => $c->session->{'tank_id'},
## FIXME: 'when' doesn't seem to be working properly with multi-values
#             constraints       => [
#                 {
#                     type    => 'Required',
#                     when    => { field => 'tank_action',
#                                  value => [ 'add/fresh', 'add/salt' ],
#                                  not   => 1,
#                                },
#                     message => 'You must select a tank.',
#                 },
#             ],
        },
        {
            name    => 'tank_action',
            type    => 'Radiogroup',
            default => $c->session->{tank_action},
            options => [
                [ 'water_test/list' => 'Water tests' ],
                [ 'view'            => 'View / edit tank details' ],
                [ 'add/salt'        => 'Add a new saltwater tank' ],
                [ 'add/fresh'       => 'Add a new freshwater tank' ],
                [ 'inventory/list'  => 'Inventory'   ],
                [ 'diary/list'      => 'Diary'       ],
            ],
            constraints => [
                'AutoSet',
                {
                    type    => 'Required',
                    message => 'You must select an action.',
                },
            ],
        },
    }

    return { 'elements' => \@elements };
}

sub select : Chained('base') :PathPart('') Args(0) FormMethod('_select_form') {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $action  = $c->request->params->{'tank_action'};
        my $tank_id = $c->request->params->{'tank_id'};

        # remember the currently-selected tank & action:
        $c->session->{tank_id}     = $tank_id;
        $c->session->{tank_action} = $action if $action !~ qr{^add};

        my $path  = q{/tank/};
           $path .= "$tank_id/" if $action !~ qr{^add};
           $path .= $action;

        $c->response->redirect($c->uri_for($path));
        $c->detach();
        return;
    }

    $c->stash->{'template'} = 'tank/select.tt2';

    return;
}

sub add : Chained('base') :PathPart('add') Args(1) {
    my ( $self, $c, $water_type ) = @_;

    $c->stash->{tank_action}    = 'add';
    $c->stash->{action_heading} = 'Add Tank';
    $c->stash->{water_type}     = $water_type;

    $c->forward('details');

    return;
}

sub edit : Chained('get_tank') :PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{tank_action}    = 'edit';
    $c->stash->{action_heading} = 'Edit';

    $c->forward('details');

    return;
}

sub view : Chained('get_tank') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{tank_action}    = 'view';
    $c->stash->{action_heading} = 'Details';

    $c->forward('details');
}

sub _details_form : Private {
    my ( $self, $c ) = @_;

    my $elements = [
        {
            name => 'tank_id',
            type => 'Hidden',
            value => $c->stash->{'tank'}{'tank_id'},
        },
        {
            name  => 'tank_name',
            type  => 'Text',
            constraints => [ 'Required' ],
        },
        {
            name  => 'water_type',
            type  => 'Select',
            empty_first       => 1,
            empty_first_label => '- Water type -',
            options => [
                [ 'salt'  => 'Salt Water'  ],
                [ 'fresh' => 'Fresh Water' ],
            ],
            constraints => [ 'Required' ],
        },
        {
            name  => 'capacity',
            type  => 'Text',
            constraints => [ 'Number' ],
        },
        {
            name  => 'length',
            type  => 'Text',
            constraints => [ 'Number' ],
        },
        {
            name  => 'width',
            type  => 'Text',
            constraints => [ 'Number' ],
        },
        {
            name  => 'depth',
            type  => 'Text',
            constraints => [ 'Number' ],
        },
        {
            name    => 'active',
            type    => 'Radiogroup',
            label_attributes => { 'class' => 'radio-inline' },
            options => [
                [ 1 => 'Yes' ],
                [ 0 => 'No'  ],
            ],
            constraints => [
                'AutoSet',
                {
                    type    => 'Required',
                    message => 'You must select an option.',
                },
            ],
        },
        {
            name => 'notes',
            type => 'Textarea',
            rows => 15,
            cols => 50,
            constraints => [ 'ASCII' ],
            filter  => [
                'TrimEdges',
                'HTMLScrubber',
                {
                    type    => 'Regex',
                    match   => qr{\r},
                    replace => '',
                }
            ],
        },
    ];

    my $test_params = $c->stash->{'tank'}{'test_params'};

    if ( ! $test_params or ! @{ $test_params } ) {
        # must be adding a new tank - fetch some defaults:
        my $type = $c->stash->{'water_type'}.'_water';
        $test_params = $c->model('Parameter')->list({ $type => 1 });

        # since we have no tank with test params, put it on the stash
        # so we can populate the form defaults from it:
        $c->stash->{'tank'}{'test_params'} = $test_params;
    }

    my @wtp_id = ();


    for my $param ( @{ $test_params } ) {
       my $id = $param->{'parameter_id'};

        push @wtp_id, $id;

        push @$elements,
        {
            name        => "wtp_${id}_parameter_id",
            type        => 'Hidden',
            constraints => [ 'Required' ],
        },
        {
            name        => "wtp_${id}_parameter",
            type        => 'Hidden',
            constraints => [ 'Required' ],
        },
        {
            name        => "wtp_${id}_title",
            type        => 'Text',
            constraints => [ 'Required' ],
        },
        {
            name        => "wtp_${id}_label",
            type        => 'Text',
            constraints => [ 'Required' ],
        },
        {
            name        => "wtp_${id}_rgb_colour",
            type        => 'Text',
            constraints => [ 'Required' ],
        },
        {
            name        => "wtp_${id}_active",
            type        => 'Checkbox',
            constraints => [ 'Required' ],
        },
        {
            name        => "wtp_${id}_chart",
            type        => 'Checkbox',
            constraints => [ 'Required' ],
        };
    }
    $c->stash->{'wtp_id'} = \@wtp_id;

    return { 'elements' => $elements };
}

sub details : Chained('get_tank') Args(0) FormMethod('_details_form') {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $params = $form->params();

        $params->{'owner_id'} = $c->user->user_id();
        delete $params->{'submit'};

        try {
            my ( $msg, $tank );

            my $tank_id = delete $params->{'tank_id'};

            if ( $tank_id ) {
                ## Don't propagate current user_id to the tank's owner!
                ## FIXME: look at implementing a 'change tank owner'?
                delete $params->{'owner_id'};

                $tank = $c->model('Tank')->update($tank_id, $params);
                $msg  = q{Updated tank details.};
            }
            else {
                $tank = $c->model('Tank')->add($params);
                $msg = q{Created new tank.};
            }

            $c->stash->{message} = $msg;

            # Edit complete - send user back to 'view' mode...
            my $path = qq{/tank/$tank->{'tank_id'}/view};

            $c->response->redirect($c->uri_for($path));
            $c->detach();
            return;
        }
        catch {
            my $err = qq{Error saving tank details: $_};
            $c->stash->{'error'} = $err;
        };
    }

    my %defaults = %{ $c->stash->{'tank'} };

    for my $param ( @{ delete $defaults{'test_params'} } ) {
       my $id = $param->{'parameter_id'};
       for my $key ( keys %{ $param } ) {
           $defaults{'wtp_'.$id.'_'.$key} = $param->{$key};
       }
    }

    $form->default_values(\%defaults);

    $c->stash(template => 'tank/details.tt2');

    return;
}

=encoding utf8

=head1 AUTHOR

Brendon Oliver <brendon.oliver@gmail.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
