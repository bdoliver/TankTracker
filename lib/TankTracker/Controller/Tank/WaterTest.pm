package TankTracker::Controller::Tank::WaterTest;
use Moose;
use namespace::autoclean;

use DateTime;
use File::Path;
use JSON;
use Try::Tiny;

BEGIN { extends q{Catalyst::Controller::HTML::FormFu} }

with q{TankTracker::TraitFor::Controller::Tank};

=head1 NAME

TankTracker::Controller::Tank::WaterTest - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub auto :Private {
    my ($self, $c) = @_;

    return 1;
}

sub list :Chained('get_tank') PathPart('water_test/list') {
    my ($self, $c, $page) = @_;

    my $tank_id = $c->stash->{'tank'}{'tank_id'};

    my $order_col = $c->user->user_preference->water_test_order_col();
    my $order_seq = $c->user->user_preference->water_test_order_seq();

    my ( $tests, $pager ) = @{ $c->model('WaterTest')->list(
        {
             'tank_id' => $tank_id,
        },
        {
            order_by => [ 
                { "-$order_seq" => "me.$order_col" },
                { '-desc'       => 'me.test_id'    },
            ],
            page     => $page || 1,
            rows     => $c->stash->{'user'}{'preferences'}{'recs_per_page'} || 10,
        },
    ) };

    if ( $pager and ref($pager) ) {
        $pager->{'what'} = 'water tests';
        $pager->{'path'} = [ '/tank', $tank_id, 'water_test/list' ];
    }

    $c->stash->{'col_headings'} = $c->model('TankWaterTestParameter')
                                    ->get_headings($c->stash->{'tank'}{'tank_id'});
    $c->stash->{'tests'} = $tests;
    $c->stash->{'pager'} = $pager;

    $c->stash->{'action_heading'} = 'Water Tests';

    $c->stash->{'add_url'}    = qq{/tank/$tank_id/water_test/add};
    $c->stash->{'chart_url'}  = qq{/tank/$tank_id/water_test/chart};
    $c->stash->{'export_url'} = qq{/tank/$tank_id/water_test/tools/export};
    $c->stash->{'import_url'} = qq{/tank/$tank_id/water_test/tools/import};

    return 1;
}

sub _test_form :Private {
    my ($self, $c) = @_;

    my $tank_id     = $c->stash->{'tank'}{'tank_id'};
    my $test_fields = $c->model('TankWaterTestParameter')->list(
        {
            tank_id => $tank_id,
            active  => 1,
        },
        {
            order_by => {
                -asc => [ qw( tank_id param_order me.parameter_id ) ]
            },
        },
    );

    # stash these so we can get the field titles into the template:
    $c->stash->{'test_fields'} = $test_fields;

    my @elements = (
        {
            name  => 'tank_id',
            type  => 'Hidden',
            value => $tank_id,
        },
        {
            name  => 'test_date',
            type  => 'Text',
            constraints => [
                {
                    type    => 'Required',
                    message => q{You must enter a test date.},
                },
            ],
        },
    );

    if ( $c->stash->{'edit_test'} ) {
        push @elements,
            {
                name => 'test_id',
                type => 'Hidden',
            };
    }

    for my $field ( @{ $test_fields } ) {
        my $param_id = $field->{'parameter_id'};

        if ( $c->stash->{'edit_test'} ) {
            push @elements,
                # if we're editing an existing test, this is the test_result_id
                # of the individual test result to be updated
                {
                    name  => "test_result_$param_id",
                    type  => 'Hidden',
                };
        }

        push @elements,
            {
                name        => "parameter_$param_id",
                type        => 'Text',
                constraints => [
                    {
                        type    => 'Required',
                        message => qq{$field->{'title'} is a required input.},
                    },
                    {
                        type    => 'Number',
                        message => qq{$field->{'title'} must be a number.},
                    },
                ],
            };
    }

    push @elements,
        {
            name => 'notes',
            type => 'Textarea',
            rows => 10,
            cols => 43,
            filter  => [
                'TrimEdges',
                'HTMLScrubber',
                {
                    type    => 'Regex',
                    match   => qr{\r},
                    replace => '',
                }
            ],
        };

    return { elements => \@elements };
}

sub add :Chained('get_tank') PathPart('water_test/add') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{'action_heading'} = 'Add Test';
    $c->stash->{'add_test'}       = 1;
    $c->forward('details');

    return;
}

sub get_test :Chained('get_tank') PathPart('water_test') CaptureArgs(1) {
    my ( $self, $c, $test_id ) = @_;

    if ( ! $test_id ) {
        ## Should never happen...
        my $error = qq{Missing test_id!};
        $c->log->fatal("get_test() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( $test_id !~ qr{\A \d+ \z}msx ) {
        my $error = qq{Invalid test_id '$test_id'};
        $c->log->fatal("get_test() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( my $test = $c->model('WaterTest')->get($test_id) ) {
        my $results = $test->{'water_test_results'};
        if ( $results and $results->[0]{'tank_id'} != $c->stash->{'tank'}{'tank_id'} ) {
            my $error = qq{Test requested ($test_id) does not belong to current tank!};
            $c->log->fatal("get_test() $error");
            $c->error($error);
            $c->detach();
            return;
        }

        $c->stash->{'water_test'} = $test;
    }
    else {
        my $error = qq{Test requested ($test_id) not found in database!};
        $c->log->fatal("get_test() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    return;
}

sub edit :Chained('get_test') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'action_heading'} = 'Edit Test';
    $c->stash->{'edit_test'}      = 1;
    $c->forward('details');

    return;
}

sub details :Chained('get_test') PathPart('water_test/details') Args(0) FormMethod('_test_form') {
    my ( $self, $c ) = @_;

    ## FIXME: make sure we have been called via add() or edit();
    ##        if we haven't, then 404 !!
    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $params = $c->forward('_water_test_params', [ $form->params() ]);

        try {
            my $test;

            if ( my $test_id = $c->stash->{'water_test'}{'test_id'} ) {
                $test = $c->model('WaterTest')->update($test_id, $params);
            }
            else {
                $test = $c->model('WaterTest')->add($params);
            }

            $c->stash->{'message'} = qq{Saved test results (test no. $test->{'test_id'}).};
            my $tank_id = $c->stash->{'tank'}{'tank_id'};
            my $path    = qq{/tank/$tank_id/water_test/list};

            $c->response->redirect($c->uri_for($path));
            $c->detach();
            return;
        }
        catch {
            $c->stash->{'error'} = qq{Error saving test results: $_};
        };
    }

    $form->default_values($c->stash->{'water_test'});

    $c->stash->{'template'} = 'tank/watertest/details.tt';
}

sub _water_test_params :Private {
    my ( $self, $c, $params ) = @_;

    my $test = {
        details => {
            'user_id'   => $c->user->user_id(),
            'test_date' => $params->{'test_date'},
            'notes'     => $params->{'notes'},
        },
    };

    my @results = ();

    my $tank_id = $c->stash->{'tank'}{'tank_id'};

    if ( $c->stash->{edit_test} ) {
        for my $p ( keys %{ $params } ) {
            if ( my ( $id ) = ( $p =~ qr{^test_result_(\d+)$} ) ) {
                push @results,
                    {
                        'tank_id'        => $params->{'tank_id'},
                        'test_id'        => $params->{'test_id'},
                        'test_result_id' => $params->{$p},
                        'test_result'    => $params->{"parameter_$id"},
                    };
            }
        }
    }
    else {
        for my $p ( keys %{ $params } ) {
            if ( my ( $id ) = ( $p =~ qr{^parameter_(\d+)$} ) ) {
                push @results,
                    {
                        'tank_id'      => $tank_id,
                        'parameter_id' => $id,
                        'test_result'  => $params->{$p},
                    };
            }
        }
    }

    $test->{'results'} = \@results;

    return $test;
}

sub view :Chained('get_test') PathPart('view') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'action_heading'} = 'View Test Details';

    $c->stash->{'template'} = 'tank/watertest/details.tt';
}

=pod

=encoding utf8

=head1 AUTHOR

Brendon Oliver <brendon.oliver@gmail.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
