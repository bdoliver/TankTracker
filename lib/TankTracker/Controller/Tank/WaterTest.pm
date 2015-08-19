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

    $c->stash->{'page_title'} = 'Water Tests';

    return 1;
}

sub list :Chained('get_tank') PathPart('water_test/list') {
    my ($self, $c, $page) = @_;

    my $tank_id = $c->stash->{'tank'}{'tank_id'};

    my ( $tests, $pager ) = @{ $c->model('WaterTest')->list(
        {
            tank_id => $tank_id,
        },
        {
            order_by => { '-desc' => 'test_date' },
            page     => $page || 1,
            rows     => $c->stash->{'user'}{'preferences'}{'recs_per_page'} || 10,
        },
    ) };

    if ( $pager and ref($pager) ) {
        $pager->{'what'} = 'water tests';
        $pager->{'path'} = [ '/tank', $tank_id, 'water_test/list' ];
    }

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

    my $elements = [
        {
            name  => 'tank_id',
            type  => 'Hidden',
            value => $c->stash->{'tank'}{'tank_id'},
        },
        {
            name  => 'test_date',
            type  => 'Text',
            constraints => [ 'Required' ],
        },
        {
            name        => 'result_ph',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
        {
            name        => 'result_ammonia',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
        {
            name        => 'result_nitrite',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
        {
            name        => 'result_nitrate',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
    ];

    if ( $c->stash->{'tank'}{'water_type'} eq 'salt' ) {
        push @$elements,
        {
            name        => 'result_salinity',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
        {
            name        => 'result_calcium',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
        {
            name        => 'result_phosphate',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
        {
            name        => 'result_magnesium',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
        {
            name        => 'result_kh',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
        {
            name        => 'result_alkalinity',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        };
    }

    push @$elements,
        {
            name        => 'temperature',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
        {
            name        => 'water_change',
            type        => 'Text',
            constraints => [ 'Required', 'Number' ],
        },
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
        },
        {
            type => 'Submit',
            name => 'submit',
        };

    return { elements => $elements };
}

sub add :Chained('get_tank') PathPart('water_test/add') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{'action_heading'} = 'Add Test';

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
        if ( $test->{'tank_id'} != $c->stash->{'tank'}{'tank_id'} ) {
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

    $c->forward('details');

    return;
}

sub details :Chained('get_test') PathPart('water_test/details') Args(0) FormMethod('_test_form') {
    my ( $self, $c ) = @_;

    ## FIXME: make sure we have been called via add() or edit();
    ##        if we haven't, then 404 !!
    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $params = $form->params();

        $params->{'user_id'} = $c->user->user_id();
        delete $params->{'submit'};

        try {
            my $test;

            my $tank_id = $c->stash->{'tank'}{'tank_id'};

            if ( my $test_id = $c->stash->{'water_test'}{'test_id'} ) {
                $test = $c->model('WaterTest')->update($test_id, $params);
            }
            else {
                $params->{'tank_id'} = $tank_id;
                $test = $c->model('WaterTest')->add($params);
            }

           $c->stash->{message} = qq{Saved test results (test no. $test->{'test_id'}).};

            my $path = qq{/tank/$tank_id/water_test/list};

            $c->response->redirect($c->uri_for($path));
            $c->detach();
            return;
        }
        catch {
            my $err = qq{Error saving test results: $_};
            $c->stash->{error} = $err;
        };
    }

    ## FIXME: make sure this doesn't clobber newly-entered values
    ##        if/when form redisplay
#     if ( not $form->submitted() and my $test = $c->stash->{'water_test'} ) {
#         $form->default_values($test);
#     }
    $form->default_values($c->stash->{'water_test'});

    $c->stash(template => 'tank/watertest/details.tt');
}

sub view :Chained('get_test') PathPart('view') Args(0) {
    my ( $self, $c ) = @_;

    # test is already on the stash by virtue of get_test()
    # so just add the meta-data so we can display it nicely:
    $c->stash->{'fields'}     = $c->model('WaterTest')->fields();
    $c->stash->{'attributes'} = $c->model('WaterTest')->attributes();

    $c->stash->{'action_heading'} = 'View Test Details';

    $c->stash(template => 'tank/watertest/details.tt');
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
