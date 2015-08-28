package TankTracker::Controller::Tank::WaterTest::Chart;
use Moose;
use namespace::autoclean;

use DateTime;
# use File::Path;
# use JSON;
# use Try::Tiny;

BEGIN { extends q{Catalyst::Controller::HTML::FormFu} }

with q{TankTracker::TraitFor::Controller::Tank};

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{'page_title'} = 'Water Tests';

    return 1;
}


## We don't use an HTML::FormFu form here - there isn't actually a form
## on the page!  Chart requests are POSTed via ajax calls triggered by
## change handlers attached to the checkboxes:
sub chart :Chained('get_tank') PathPart('water_test/chart') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{'action_heading'} = 'Graph Test Results';

    my $chart_cols = $c->model('WaterTest')->test_columns({
        'tank_id' => $c->stash->{'tank'}{'tank_id'},
        'chart'   => 1
    });

    # this gives us the tank's water test parameter IDs in their
    # desired sequence:
    my @cols = sort { ( ($a->{param_order}  || 0) <=> ($b->{param_order}  || 0) )
                            ||
                      ( ($a->{parameter_id} || 0) <=> ($b->{parameter_id} || 0) )
               } values %{ $chart_cols };

    $c->stash->{'chart_columns'} = \@cols;
    return;
}

sub chart_data :Chained('get_tank') PathPart('water_test/chart/data') Args(0) {
    my ($self, $c) = @_;

    my $params = $c->request->body_data();

    # must have either start or end date requested, and at least one of
    # the result_* parameters must be true:
    if ( $params->{'edate'} or $params->{'sdate'} ) {
        if ( my $parameter_ids = $params->{'parameter_id'} ) {
            my $search = {
                'tank_id'      => $c->stash->{'tank'}{'tank_id'},
                'parameter_id' => { '-in' => $parameter_ids },
                '-and'         => [],
            };

            if ( $params->{'edate'} ) {
                push @{ $search->{'-and'} },
                    [ 'test_date' => { '<=', $params->{'edate'} } ];
            }
            if ( $params->{'sdate'} ) {
                push @{ $search->{'-and'} },
                    [ 'test_date' => { '>=', $params->{'sdate'} } ];
            }

            my $results = $c->model('WaterTest')->chart_data(
                $search,
                $params->{'show_notes'},
            );

            $c->stash->{'chart_data'} = $results;
        }
    }

    $c->forward('View::JSON');

    return;
}

__PACKAGE__->meta->make_immutable;

1;
