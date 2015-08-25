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
            constraints       => [
                {
                    type    => 'Required',
                    when    => { field => 'tank_action',
                                 values => [ 'add/fresh', 'add/salt' ],
                                 not   => 1,
                               },
                    message => 'You must select a tank.',
                },
            ],
        };
#         {
#             name    => 'tank_action',
#             type    => 'Radiogroup',
#             default => $c->session->{'tank_action'},
#             options => [
#                 [ 'water_test/list' => 'Water tests' ],
#                 [ 'view'            => 'View / edit tank details' ],
#                 [ 'add/salt'        => 'Add a new saltwater tank' ],
#                 [ 'add/fresh'       => 'Add a new freshwater tank' ],
#                 [ 'inventory/list'  => 'Inventory'   ],
#                 [ 'diary/list'      => 'Diary'       ],
#             ],
#             constraints => [
#                 'AutoSet',
#                 {
#                     type    => 'Required',
#                     message => 'You must select an action.',
#                 },
#             ],
#         },
    }

    return { 'elements' => \@elements };
}

sub select : Chained('base') :PathPart('') Args(0) FormMethod('_select_form') {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {

        my $tank_id = $c->request->params->{'tank_id'};

        $c->session->{tank_id} = $tank_id;

        if ( $c->forward('user_can_access_tank') ) {
            $c->stash->{'tabs'} = [
                { 'href'   => qq{/tank/$tank_id/water_test/list},
                  'target' => q{water-test},
                  'title'  => q{Water Tests},
                },
                { 'href'   => qq{/tank/$tank_id/water_test/chart},
                  'target' => q{graph-test},
                  'title'  => q{Graph Tests},
                },
                { 'href'   => qq{/tank/$tank_id/water_test/tools/export},
                  'target' => q{export-test},
                  'title'  => q{Export Tests},
                },
                { 'href'   => qq{/tank/$tank_id/water_test/tools/import},
                  'target' => q{import-test},
                  'title'  => q{Import Tests},
                },
                { 'href'   => qq{/tank/$tank_id/inventory/list},
                  'target' => q{inventory},
                  'title'  => q{Inventory},
                },
                { 'href'   => qq{/tank/$tank_id/diary/list},
                  'target' => q{diary},
                  'title'  => q{Diary},
                },
                { 'href'   => qq{/tank/$tank_id/view},
                  'target' => q{details},
                  'title'  => q{Tank Details},
                },
            ];
        }
        else {
            $c->stash->{'error'} =
                q{You do not have access to the selected tank.'};
        }
    }
    $c->stash->{'template'} = 'tank/select.tt';

    return;
}

sub add : Chained('base') :PathPart('add') Args(1) {
    my ( $self, $c, $water_type ) = @_;

    $c->stash->{'tank_action'}    = 'add';
    $c->stash->{'action_heading'} = sprintf(
                                        'Add %s Water Tank',
                                        ucfirst($water_type)
                                    );
    $c->stash->{'water_type'}     = $water_type;

    $c->forward('details');

    return;
}

sub edit : Chained('get_tank') :PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'tank_action'}    = 'edit';
    $c->stash->{'action_heading'} = 'Edit';

    $c->forward('details');

    return;
}

sub view : Chained('get_tank') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'tank_action'}    = 'view';
    $c->stash->{'action_heading'} = 'Details';

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
            constraints => [
                {
                    type    => 'Required',
                    message => q{Tank name cannot be blank.},
                },
                {
                    type    => 'Printable',
                    message => q{Tank name must contain only printable characters.},
                },
            ],
        },
        {
            name  => 'water_type',
            type  => 'Hidden',
            value => $c->stash->{'water_type'},
        },
        {
            name => 'capacity_units',
            type => 'Select',
            empty_first => 1,
            empty_first_label => '- Select -',
            options => [
                [ 'litres'      => 'L'       ],
                [ 'gallons'     => 'Gal'     ],
                [ 'us gallons'  => 'US Gal'  ],
            ],
            constraints => [
                {
                    type    => 'Required',
                    message => 'You must select capacity units',
                },
            ],
        },
        {
            name  => 'capacity',
            type  => 'Text',
            constraints => [
                {
                    type    => 'Number',
                    message => q{Capacity must be a number.},
                },
                {
                    type    => 'MinRange',
                    minimum => 0,
                    message => q{Capacity must be zero or greater.},
                },
            ],
        },
        {
            name => 'dimension_units',
            type => 'Select',
            empty_first => 1,
            empty_first_label => '- Select -',
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
                    message => 'You must select dimension units',
                },
            ],
        },
        {
            name  => 'length',
            type  => 'Text',
            constraints => [
                {
                    type    => 'Length',
                    message => q{Length must be a number.},
                },
                {
                    type    => 'MinRange',
                    minimum => 0,
                    message => q{Length must be zero or greater.},
                },
            ],
        },
        {
            name  => 'width',
            type  => 'Text',
            constraints => [
                {
                    type    => 'Number',
                    message => q{Width must be a number.},
                },
                {
                    type    => 'MinRange',
                    minimum => 0,
                    message => q{Width must be zero or greater.},
                },
            ],
        },
        {
            name  => 'depth',
            type  => 'Text',
            constraints => [
                {
                    type    => 'Number',
                    message => q{Depth must be a number.},
                },
                {
                    type    => 'MinRange',
                    minimum => 0,
                    message => q{Depth must be zero or greater.},
                },
            ],
        },
        {
            name    => 'temperature_scale',
            type    => 'Radiogroup',
            label_attributes => { 'class' => 'radio-inline' },
            options => [
                [ 'C' => 'Celsius'    ],
                [ 'F' => 'Fahrenheit' ],
            ],
            constraints => [
                'AutoSet',
                {
                    type    => 'Required',
                    message => 'You must select a temperature scale.',
                },
            ],
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
                    message => 'Active? You must select an option (yes/no).',
                },
            ],
        },
        {
            name => 'notes',
            type => 'Textarea',
            rows => 20,
            cols => 50,
            constraints => [
                {
                    type    => 'ASCII',
                    message => q{Notes must contain only ASCII characters.},
                },
            ],
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
        $test_params = $c->model('WaterTestParameter')->list(
            {
                $type => 1
            },
            {
                'order_by' => { '-asc' => [ qw( parameter_id ) ] },
            },
        );

        # set the active & show_chart flags to default for all params:
        map { $_->{'active'} = $_->{'chart'} = 1 } @{ $test_params };

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
        },
        {
            name        => "wtp_${id}_parameter",
            type        => 'Hidden',
        },
        {
            name        => "wtp_${id}_title",
            type        => 'Text',
            constraints => [
                {
                    type    => 'Required',
                    message => qq{Title is required for parameter id #$id},
                },
            ],
        },
        {
            name        => "wtp_${id}_label",
            type        => 'Text',
            constraints => [
                {
                    type    => 'Required',
                    message => qq{Label is required for parameter id #$id},
                },
            ],
        },
        {
            name        => "wtp_${id}_rgb_colour",
            type        => 'Text',
            constraints => [
                {
                    type    => 'Required',
                    message => qq{RGB colour is required for parameter id #$id},
                },
                {
                    type    => 'Regex',
                    regex   => '^#[\da-fA-F]{6}$',
                    message => qq{RGB colour for parameter id #id must be of the form '#ffffff'},
                },
            ],
        },
        {
            name        => "wtp_${id}_active",
            type        => 'Checkbox',
        },
        {
            name        => "wtp_${id}_chart",
            type        => 'Checkbox',
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

        my %wtp_fields = map  { $_ => delete $params->{$_} }
                         grep { $_ =~ qr{^wtp_} }
                         keys %$params;

        try {
            my ( $msg, $tank );

            my $tank_id = delete $params->{'tank_id'};

            ## prepare the water test parameter fields for update:
            my $wtp_fields = $c->forward(
                '_prepare_water_test_params',
                [ \%wtp_fields ]
            );

            if ( $tank_id ) {
                ## Don't propagate current user_id to the tank's owner!
                ## FIXME: look at implementing a 'change tank owner'?
                delete $params->{'owner_id'};

                $tank = $c->model('Tank')->update($tank_id, $params, $wtp_fields);
                $msg  = q{Updated tank details.};
            }
            else {
                $tank = $c->model('Tank')->add($params, $wtp_fields);
                $msg = q{Created new tank.};
            }

            $c->stash->{'message'} = $msg;

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

    $c->stash->{'template'} = 'tank/details.tt';

    return;
}

## Massages the water test parameter fields into a form suitable
## for updating into the database:
sub _prepare_water_test_params :Private {
    my ( $self, $c, $fields ) = @_;

    my %params = ();

    my $field_rx = qr{ ^wtp_(\d+)_(.+)$ }xi;

    for my $field ( keys %{ $fields } ) {
        my ( $id, $param ) = ( $field =~ $field_rx );

        $params{$id} ||= {
            'parameter_id' => $id,
        };

        $params{$id}{$param} = $fields->{$field};
    }

    return [ map { $params{$_} } sort { $a <=> $b } keys %params ];
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
