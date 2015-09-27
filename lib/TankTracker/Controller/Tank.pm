package TankTracker::Controller::Tank;
use Moose;
use namespace::autoclean;

use File::MimeInfo::Magic;
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

    $c->stash->{'active_tab'} = 'tank';

    return 1;
}

sub _select_form :Private {
    my ( $self, $c ) = @_;

    my $order_col = $c->user->user_preference->tank_order_col();
    my $order_seq = $c->user->user_preference->tank_order_seq();

    my @tanks = @{ $c->model('UserTank')->list(
        {
            user_id => $c->user->user_id(),
        },
        {
            order_by => { "-$order_seq" => $order_col },
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
            default           => @tanks == 1
                                 ? $tanks[0]->{'tank_id'}
                                 : $c->session->{'tank_id'},
            constraints       => [
                {
                    type    => 'Required',
                    when    => {
                        field  => 'tank_action',
                        values => [ 'add' ],
                        not    => 1,
                    },
                    message => 'You must select a tank.',
                },
            ],
        },
        {
            name    => 'tank_action',
            type    => 'Radiogroup',
            default => $c->session->{'tank_action'},
            options => [
                [ 'water_test/list' => 'Water tests' ],
                [ 'view'            => 'View / edit tank details' ],
                [ 'upload_photo'    => 'Upload tank photo' ],
                [ 'add'             => 'Add a new tank' ],
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
    else {
        push @elements,
        {
            name    => 'tank_action',
            type    => 'Radiogroup',
            default => $c->session->{'tank_action'},
            options => [
                [ 'add' => 'Add a new tank' ],
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

    if ( not $form->get_field({ name => 'tank_id', type => 'Select' }) ) {
        # user has no tanks - if they are an owner, then redirect them to 
        # add one; otherwise we can't do anything for them...
        if ( $c->user->role() eq 'owner' or $c->user->role() eq 'admin' ) {
            $c->response->redirect($c->uri_for('/tank/add'));
            $c->detach();
            return;
        }
        else {
            $c->stash->{'error'} =
                q{There are no tanks available to you, and you have no permission to create one.};
        }
    }

    if ( $form->submitted_and_valid() ) {
        my $action  = $c->request->params->{'tank_action'};
        my $tank_id = $c->request->params->{'tank_id'};

        # remember the currently-selected tank & action:
        $c->session->{tank_id}     = $tank_id;
        $c->session->{tank_action} = $action;

        my $path  = q{/tank/};
           $path .= "$tank_id/" if $action ne q{add};
           $path .= $action;

        $c->response->redirect($c->uri_for($path));
        $c->detach();
        return;
    }

    if ( my $msg = $c->flash->{'message'} ) {
        $c->stash->{'message'} = $msg;
    }

    $c->stash->{'template'} = 'tank/select.tt';

    return;
}

sub _water_type_form :Private {
    my ( $self, $c ) = @_;

    return { 'elements' =>
        [
            {
                name => 'water_type',
                type => 'Select',
                empty_first => 1,
                empty_first_label => '- Select -',
                options => [
                    [ 'fresh' => 'Fresh water' ],
                    [ 'salt'  => 'Salt water'  ],
                ],
                constraints => [
                    {
                        type    => 'Required',
                        message => 'You must select a water type',
                    },
                ],
            },
        ],
    };
}

sub add : Chained('base') :PathPart('add') FormMethod('_water_type_form') {
    my ( $self, $c, $water_type ) = @_;

    $c->stash->{'tank_action'} = 'add';
    $c->stash->{'page_title'}  = sprintf(
                                    'Add %s Tank',
                                    $water_type
                                        ? ucfirst("$water_type Water")
                                        : 'New'
                                 );

    if ( $water_type ) {
        $c->stash->{'water_type'} = $water_type;
        $c->forward('details');
        $c->detach();
        return;
    }

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {

        my $params = $form->params();

        if ( my $water_type = $params->{'water_type'} ) {
            $c->stash->{'water_type'} = $water_type;
            $c->response->redirect($c->uri_for(qq{/tank/add/$water_type}));
            $c->detach();
            return;
        }
    }

    $c->stash->{'template'} = 'tank/water_type.tt';

    return;
}

sub edit : Chained('get_tank') :PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'tank_action'}    = 'edit';
    $c->stash->{'action_heading'} = 'Edit Details';
    $c->stash->{'water_type'}     = $c->stash->{'tank'}{'water_type'};
    $c->forward('details');

    return;
}

sub view : Chained('get_tank') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'tank_action'}    = 'view';
    $c->stash->{'action_heading'} = 'Details';
    $c->stash->{'water_type'}     = $c->stash->{'tank'}{'water_type'};
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
                    message => qq{RGB colour for parameter id #$id must be of the form '#ffffff'},
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
                $msg  = q{Updated details: }.$tank->{'tank_name'};
            }
            else {
                $tank = $c->model('Tank')->add($params, $wtp_fields);
                $msg = q{Created new tank: }.$tank->{'tank_name'};
            }

            # Make sure we have the photo dir for this tank:
            $c->forward('photo_dir', [ $tank_id ]);

            $c->flash->{'message'} = $msg;

            delete $c->session->{'tank_action'}; # re-set action selection

            # Edit complete - send user back to 'tank select' page
            $c->response->redirect($c->uri_for('/tank'));

            $c->detach();
            return;
        }
        catch {
            my $err = qq{Error saving tank details: $_};
            $c->stash->{'error'} = $err;
        };
    }

    if ( $c->stash->{'tank'} ) {
        my %defaults = %{ $c->stash->{'tank'} };

        for my $param ( @{ delete $defaults{'test_params'} } ) {
           my $id = $param->{'parameter_id'};
           for my $key ( keys %{ $param } ) {
               $defaults{'wtp_'.$id.'_'.$key} = $param->{$key};
           }
        }

        $form->default_values(\%defaults);
    }

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

    for my $id ( keys %params ) {
        if ( ! exists $params{$id}{'active'} ) {
            $params{$id}{'active'} = 0;
        }
    }

    return [ map { $params{$_} } sort { $a <=> $b } keys %params ];
}

sub _upload_photo_form :Private {
    my ($self, $c ) = @_;

    my $elements = [
        {
            name => 'upload_photo',
            type => 'File',
            attributes => {
                'id' => 'upload_photo',
                'data-preview-file-type' => 'image',
                'data-wrap-text-length' => 45,
            },
            constraints => [
                {
                    type    => 'Required',
                    message => 'No file selected for upload.',
                },
            ],
        },
        {
            name => 'caption',
            type => 'Text',
        },
    ];

    return { 'elements' => $elements };
}

sub upload_photo :Chained('get_tank') PathPart('upload_photo') Args(0) FormMethod('_upload_photo_form') {
    my ($self, $c ) = @_;

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {

##FIXME: check out w.r.t limiting/aborting upload based on file size...
## http://stackoverflow.com/questions/3090574/how-to-cancel-a-file-upload-based-on-file-size-in-catalyst
        if ( my $upload = $c->request->upload('upload_photo') ) {
            try {
                my $tank_id   = $c->stash->{'tank'}{'tank_id'};
                my $photo_dir = $c->forward('photo_dir', [ $tank_id ]);

                # Sanity check!
                if ( ! $photo_dir or ! -d $photo_dir ) {
                    $c->log->error("Refuse upload: photo dir ($photo_dir) not found!");
                    die 'Cannot upload photos - tank photo directory does not exist';
                }

                my $mimetype = mimetype($upload->fh());
                my $file     = $upload->basename();

                if ( $mimetype !~ qr{^image/} ) {
                    $c->log->warn("Refuse upload: $file mimetype=$mimetype");
                    die q{Cannot upload selected file - it doesn't look like an photo!};
                }

                my $target  = qq{$photo_dir/$file};
                my $caption = $form->params()->{'caption'};

                if ( ! $upload->copy_to($target) ) {
                    $c->log->error("Failed to copy '$file' to '$target': $!");
                    die q{Upload failed - cannot copy file to tank photo directory};
                }

                # create a tank_photo record:
                $c->model('TankPhoto')->add({
                    tank_id   => $tank_id,
                    user_id   => $c->user->user_id(),
                    file_name => $file,
                    caption   => $caption,
                });

                # A little brutal, but ensures the caption field gets
                # cleared after a successful upload...
                $c->flash->{'upload_result'} = qq{Uploaded $file ok};
                $c->response->redirect($c->uri_for(qq{/tank/$tank_id/upload_photo}));
                $c->detach();
                return;
            }
            catch {
                $c->stash->{'upload_error'} = $_;
            };
        }
    }

    if ( $c->flash->{'upload_result'} ) {
        $c->stash->{'upload_result'} = $c->flash->{'upload_result'};
    }
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
