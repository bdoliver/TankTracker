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

    return;
}

sub chart_data :Chained('get_tank') PathPart('water_test/chart_data') Args(0) {
    my ($self, $c) = @_;

    my $params = $c->request->body_params();

    $c->stash->{'chart_data'} = [];

    # must have either start or end date requested, and at least one of
    # the result_* parameters must be true:
    if ( $params->{'edate'} or $params->{'sdate'} ) {
        my @cols = grep  { $params->{$_}      }
                   grep  { $_ =~ qr{^result_} }
                   keys %{ $params            };

        if ( @cols ) {
            my $search = {
                'tank_id' => $c->stash->{'tank'}{'tank_id'},
                '-and'    => [],
            };

            if ( $params->{'edate'} ) {
                push @{ $search->{'-and'} },
                    [ 'test_date' => { '<=', $params->{'edate'} } ];
            }
            if ( $params->{'sdate'} ) {
                push @{ $search->{'-and'} },
                    [ 'test_date' => { '>=', $params->{'sdate'} } ];
            }

            # must always have the test_date (otherwise there's nothing
            # to graph!)
            push @cols, 'test_date';

            if ( $params->{'show_notes'} ) {
                push @cols, 'notes';  # user wants notes in the tooltips
            }

            my $results = $c->model('WaterTest')->chart_data(
                $search,
                {
                    columns  => \@cols,
                    order_by => { '-asc' => 'test_date' },
                },
            );

            $c->stash->{'chart_data'} = $results;
        }
    }

    $c->forward('View::JSON');

    return;
}

__PACKAGE__->meta->make_immutable;

1;
