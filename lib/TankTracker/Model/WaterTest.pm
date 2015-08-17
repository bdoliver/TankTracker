package TankTracker::Model::WaterTest;

use strict;

use Hash::Ordered;

use Moose;
use Text::CSV_XS;
use Try::Tiny;
use DateTime::Format::Pg;

use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'WaterTest',
);

sub add {
    my ( $self, $params ) = @_;

    my $details = delete $params->{'details'} or
        die qq{WaterTest::add() requires hashref with 'details' key\n};
    my $results = delete $params->{'results'} or
        die qq{WaterTest::add() requires hashref with 'results' key\n};

    my $test;

    try {
        my $test_id;
        my $notes = delete $details->{'notes'};

        $self->schema->txn_do(
            sub {
                $test    = $self->resultset->create($details);
                $test_id = $test->test_id();

                my $rs = $self->schema->resultset('WaterTestResult');

                for my $result ( @{ $results } ) {
                    $result->{'test_id'} = $test_id;
                    $rs->create($result);
                }
            }
        );

        $self->add_diary({
            'tank_id'    => $results->[0]{'tank_id'},
            'user_id'    => $test->user_id(),
            'diary_note' => $notes || q{Recorded water test results},
            'test_id'    => $test->test_id(),
        });
    }
    catch {
        die $_;
    };

    return $self->deflate($test);
}

sub update {
    my ( $self, $test_id, $params ) = @_;

    my $details = delete $params->{'details'} or
        die qq{WaterTest::update() requires hashref with 'details' key\n};
    my $results = delete $params->{'results'} or
        die qq{WaterTest::update() requires hashref with 'results' key\n};

    my $test;

    try {
        my $notes = delete $details->{'notes'};

        my $tank_id;

        $self->schema->txn_do(
            sub {
                $test = $self->resultset->find($test_id);

                $test->update($details);

                my $rs = $self->schema->resultset('WaterTestResult');

                for my $result ( @{ $results } ) {
                    my $test_rec = $rs->find({
                        'test_result_id' => $result->{'test_result_id'},
                    }) or
                        die "Cannot find test_result_id #$result->{'test_result_id'}\n";

                    # sanity check:
                    $test_rec->tank_id() == $result->{'tank_id'} or
                        die "test_result_id #$result->{'test_result_id'} does not belong to current tank!\n";
                    $test_rec->test_id() == $result->{'test_id'} or
                        die "test_result_id #$result->{'test_result_id'} does not belong to current test!\n";

                    $test_rec->test_result($result->{'test_result'});

                    # only save if something has changed...
                    $test_rec->update() if $test_rec->is_changed();

                    # keep track of which tank these results are for so we
                    # can do a diary note for the update
                    $tank_id ||= $result->{'tank_id'};
                }
            }
        );

        $self->add_diary({
            'tank_id'    => $tank_id,
            'user_id'    => $details->{'user_id'},
            'diary_note' => $notes || 'Updated water test results',
            'test_id'    => $test_id,
        });
    }
    catch {
        die $_;
    };

    return 1;
}

sub get {
    my ( $self, $test_id ) = @_;

    my ( $rec, undef ) = @{ $self->list({'me.test_id' => $test_id}) };

    return undef if ( ! $rec or ! @$rec );

    my $test = $rec->[0];

    ## Munge test into something suitable for providing the form default
    ## values:
#     my $diary = delete $test->{'diary'};
#
#     $test->{'notes'} = $diary->{'diary_note'} if $diary;

    my $results = delete $test->{'water_test_results'} || [];

    for my $result ( @{ $results } ) {
        my $param_id = $result->{'parameter_id'};

        $test->{'tank_id'} ||= $result->{'tank_id'};
        $test->{"test_result_$param_id"} = $result->{'test_result_id'};
        $test->{"parameter_$param_id"}   = $result->{'test_result'};
    }

    return $test;
}

sub _list_args {
    my ( $self, $search, $args ) = @_;

    # in case we get passed nothing, we will attempt to return
    # sane stuffs...
    $search ||= {};
    $args   ||= {};

    # tank_id & parameter are actually on the water_test_results record,
    # so adjust search params accordingly:
    for my $col ( qw(tank_id parameter_id) ) {
        if ( my $attr = delete $search->{$col} ) {
            $search->{"water_test_results.$col"} = $attr;
        }
    }

    $args->{'prefetch'} ||= [
        { 'water_test_results' => 'tank_water_test_parameter' },
        'diaries',
    ];

    ## Ensure results are orderd by param_order / param_id.
    my $order_by = delete $args->{'order_by'};

    if ( ! $order_by or ref($order_by) eq 'HASH' ) {
        $order_by = [ $order_by ];
    }

    # need to ensure the results are in the correct order:
    push @{ $order_by },
        { '-asc'  =>
            [
                'tank_water_test_parameter.param_order',
                'tank_water_test_parameter.parameter_id'
            ]
        };

    $args->{'order_by'} = $order_by;

    return ( $search, $args );
}

## We override the Base class' list() method because we need to munge
## the test results into something more useful. It also saves us from
## having to have the ugly search criteria for tank_id (which is on the
## water_test_result record NOT the water_test record!); AND the ugly
## prefetch crap we need (to make sure we get all the col headings & notes)
## all jammed into the caller's arg list.
sub list {
    my ( $self, $search, $args ) = @_;

    ( $search, $args ) = $self->_list_args($search, $args);

    if ( $args->{'no_deflate'} ) {
        return $self->SUPER::list($search,$args);
    }

    my $has_pager = $args->{'page'} || 0;

    my $list = $self->SUPER::list($search,$args);

    my ( $rows, $pager );

    if ( $has_pager ) {
        ( $rows, $pager ) = @{ $list };
    }
    else {
        $rows = $list;
    }

    ## When list() is called by get() there will only be one row
    ## returned as hashref instead of an arrayref (of one hashref):
    $rows = [ $rows ] if ref($rows) eq 'HASH';

    for my $row ( @{ $rows } ) {
        for my $result ( @{ $row->{'water_test_results'} } ) {
            my $params = delete $result->{'tank_water_test_parameter'};

            $result = {
                %{ $result },
                %{ $params },
            };
        }
    }

    return $has_pager ? [ $rows, $pager ] : $rows;
}

sub _get_headings {
    my ( $self, $row ) = @_;

    my @cols = $self->columns();

    my ( @headings, @errors );

    for my $hdg ( @{ $row } ) {
        if ( grep { lc $hdg eq $_ } @cols ) {
            push @headings, $hdg;
        }
        else {
            push @errors, $hdg;
        }
    }

    die "Invalid column names: ".join(", ", @errors) if @errors;

    # make sure we have at least date + 1 result column:
    die "No 'test_date' column in upload"
        if not grep { $_ eq 'test_date' } @headings;

    die "Need at least one result_* column in upload"
        if not grep { $_ =~ qr{ \A result_ }msix } @headings;

    ## FIXME: should also check for duplicate columns?

    return \@headings;
}

## NB: import_tests() is expected to be called within an eval{} or
##     try/catch block in order to simplify error reporting to the
##     caller.
sub import_tests {
    my ( $self, $args ) = @_;

    for my $arg ( qw( tank_id user_id fh ) ) {
        $args->{$arg} or
        die qq{import_tests() missing '$arg' parameter!};
    }

    my $fh      = $args->{'fh'};
    my $user_id = $args->{'user_id'};
    my $current_tank_id = $args->{'tank_id'};

    my $csv = Text::CSV_XS->new({ binary => 1, empty_is_undef => 1});

    # first line s/be headings:
    my $headings = $self->_get_headings($csv->getline($fh));

    $csv->column_names($headings);

    my $rec_no;

    $self->txn_begin();

    eval {
        ## FIXME: should we set an upper limit on records loaded?
        CSV: while ( my $row = $csv->getline_hr($fh) ) {

            $rec_no = $csv->record_number();

            try {
                my $dt = DateTime::Format::Pg->parse_datetime($row->{'test_date'});
            }
            catch {
                die "Record #$rec_no: has invalid test_date.";
            };

            if ( my $test_id = delete $row->{'test_id'} ) {
                my $test = $self->get($test_id);

                $test or
                    die "Record #$rec_no: test ID $test_id not found in database.";

                my $tank_id = delete $row->{'tank_id'};

                if ( $tank_id ) {
                    ( $tank_id == $test->{'tank_id'} ) or
                        die "Record #$rec_no: test with ID $test_id belongs to different tank in database.";

                    my $tank = $self->schema->resultset('Tank')->find($tank_id);

                    ( $user_id == $tank->owner_id() ) or
                        die "Record #$rec_no: you do not own the tank for test ID $test_id.";
                }

                $self->update($test_id, $row) or
                    die "Record #$rec_no: failed to update test ID $test_id.";

                next CSV;
            }

            ## If the test is not for a specific tank, then assume the currently
            ## selected tank:

            my $tank_id = delete $row->{'tank_id'} || $current_tank_id;

            my $tank = $self->schema->resultset('Tank')->find($tank_id);

            $tank or
                die "Record #$rec_no: tank #$tank_id not found in database.";

            ( $user_id == $tank->owner_id() ) or
                die "Record #$rec_no: you do not own tank #$tank_id.";

            # make sure the row has a valid tank_id
            $row->{'tank_id'} = $tank_id;
            $row->{'user_id'} = $user_id;

            $self->add($row) or
                die  "record #$rec_no: failed to import test results.";
        }
    };

    if ( my $error = $@ ) {
        $self->rollback();
        die $error;
    }

    $self->txn_commit();

    return "Imported $rec_no test records.";
}

sub export_column_names {
    return [ qw(
            tank_id
            tank_name
            owner_id
            owner_first_name
            owner_last_name
            test_id
            test_date
            user_id
            tester_first_name
            tester_last_name
            parameter
            test_result
        ) ];
}

sub export_tests {
    my ( $self, $search ) = @_;

    my $args = {
        order_by => { '-asc' => [ qw(tank_id test_date) ] },
        columns  => $self->export_column_names(),
    };

    return $self->schema->resultset('TankWaterTestResultView')->search(
        $search,
        $args,
    );
}

## ============================================================================
## The following methods are exclusively used when generating test result data
## suitable for graphing by jquery.flot:
## -------------------------------------
## chart_columns() is called by Controller::WaterTest::Chart to determine the
## checkboxes required for the chart page.
sub chart_columns {
    my ( $self, $tank_id ) = @_;

    my $cols = $self->schema->resultset('WaterTestParameterView')->search(
        {
            tank_id  => $tank_id,
            chart    => 1, ## only test parameters available for charting
        },
        {
            order_by => {
                '-asc' => [ qw( param_order parameter_id ) ],
            },
        },
    );

    $cols->result_class('DBIx::Class::ResultClass::HashRefInflator');
    my @cols = $cols->all();

    return { map { $_->{'parameter_id'} => $_ } @cols };
}

## chart_data() is requested via callback from the generateChart() javascript
## function which is attached to the checkbox change handlers on the chart
## page (refer TankTrackerChart.js)
sub chart_data {
    my ( $self, $search, $show_notes ) = @_;

    my $tests = $self->list(
        $search,
        {
            # NB: jquery.flot's time series requires the test_date to
            # be in epoch milliseconds, so add a column to the search
            # query to calculate the value.  The scalarref is required
            # otherwise DBIx thinks it is a column name & prepends 'me.'
            # to it!
            '+select'  => [ \'extract(epoch from test_date) * 1000' ],
            '+as'      => [ 'timestamp' ],
            'order_by' => { '-asc' => 'test_date' },
        },
    );

    my %results = ();
    my $axis    = 0;

    ## massage test results into format required for charting.
    for my $test ( @{ $tests } ) {
        my $notes = join('<br />',
                         map { $_->{'diary_note'} } @{ $test->{'diaries'} } );

        for my $result ( @{ $test->{'water_test_results'} } ) {
            my $parameter = $result->{'parameter'};

            $results{$parameter} ||= {
                'label' => $result->{'label'},
                'color' => $result->{'rgb_colour'},
                'xaxis' => 1,
                'yaxis' => ++$axis,
                'grid'  => { 'hoverable' => 1 },
                'data'  => [],
            };

            my $row_data = [
                $test->{'timestamp'},
                $result->{'test_result'},
            ];

            push @$row_data, $notes if ( $show_notes and $notes );

            push @{ $results{$result->{'parameter'}}{'data'} }, $row_data;
        }
    }

    ## return the results as an array ordered by it's yaxis value:
    return [
        map  { $_ }
        sort { $a->{'yaxis'} <=> $b->{'yaxis'} }
        values %results
    ];
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
