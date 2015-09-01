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

                my @result_ids = grep { $_->{'test_result_id'} } @{ $results };

                if ( @result_ids == @{ $results } ) {
                    ## all results have an existing test_result_id
                    ## so we can update the records:
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
                else {
                    ## the list of test results don't all have existing
                    ## test_result_id to match, so delete existing records
                    ## & insert new (this will likely be the case when
                    ## using the import facility):
                    $rs->search({'test_id' => $test_id})->delete();
                    for my $result ( @{ $results } ) {
                        $result->{'test_id'} = $test_id;
                        $rs->create($result);
                    }
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
    my $results = delete $test->{'water_test_results'} || [];

    for my $result ( @{ $results } ) {
        my $param_id = $result->{'parameter_id'};

        $test->{'tank_id'}             ||= $result->{'tank_id'};
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

sub _get_import_headings {
    my ( $self, $row ) = @_;

    my $cols = [ $self->schema->resultset('WaterTestCsvView')->result_source->columns() ];

    my ( @headings, @errors );

    for my $hdg ( @{ $row } ) {
        if ( grep { lc $hdg eq $_ } @{ $cols } ) {
            push @headings, $hdg;
        }
        else {
            push @errors, $hdg;
        }
    }

    die "Invalid column names: ".join(", ", @errors) if @errors;

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
    my $tank_id = $args->{'tank_id'};

    my $csv = Text::CSV_XS->new({ binary => 1, empty_is_undef => 1});

    # first line s/be headings:
    my $headings = $self->_get_import_headings($csv->getline($fh));

    $csv->column_names($headings);

    my $rec_no;

    try {
        $self->txn_begin();

        my $current_test    = {};
        my $tank_parameters;
        my $current_tank_id;

        ## FIXME: should we set an upper limit on records loaded?
        CSV: while ( my $row = $csv->getline_hr($fh) ) {

            $rec_no = $csv->record_number();

            # test records default to currently-selected tank if not
            # otherwise provided in the import record:
            $row->{'tank_id'} ||= $tank_id;

            try {
                # this only checks date validity... ergo the lexical scoping:
                my $dt = DateTime::Format::Pg->parse_datetime($row->{'test_date'});
            }
            catch {
                die "Record #$rec_no: has invalid test_date.";
            };

            if ( $row->{'test_id'} and
                 $row->{'test_id'} != $current_test->{'test_id'} ) {
                # updating an existing test record:
                $self->update($current_test);
                delete $current_test->{'details'};
            }
            elsif ( $row->{'test_date'} ne $current_test->{'test_date'} ) {
                # adding a new test record:
                $self->add($current_test);
                delete $current_test->{'details'};
            }

            if ( ! $tank_parameters or ( $row->{'tank_id'} != $current_tank_id ) ) {
                # get parameters for current tank:
                $current_tank_id = $row->{'tank_id'};
                $tank_parameters = {};
                my $param = $self->schema->resultset('WaterTestParameterView')
                                 ->search({'tank_id' => $row->{'tank_id'}});
                while ( my $p = $param->next() ) {
                    $tank_parameters->{$p->parameter()} = $p->parameter_id();
                }
            }

            if ( ! $current_test->{'details'} ) {
               $current_test->{'details'} = {
                    'test_id'   => $row->{'test_id'},
                    'test_date' => $row->{'test_date'},
                    'user_id'   => $row->{'user_id'} || $user_id,
                    'notes'     => 'Imported water test',
                };
                $current_test->{'results'} = [],
            }

            push @{ $current_test->{'results'} },
                {
                    'tank_id'      => $row->{'tank_id'},
                    'test_id'      => $row->{'test_id'},
                    'parameter_id' => $tank_parameters->{$row->{'parameter'}},
                    'test_result'  => $row->{'test_result'},
                };
        }

        # flush remaining record to DB:
        if ( $current_test->{'test_id'} ) {
             # updating an existing test record:
             $self->update($current_test);
        }
        else {
            # adding a new test record:
            $self->add($current_test);
        }

        $self->txn_commit();
    }
    catch {
        $self->rollback();
        die $_;
    };

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
    my ( $self, $search, $args ) = @_;

    $args ||= {
        order_by => { '-asc' => [ qw(tank_id test_date) ] },
    };

    return $self->schema->resultset('WaterTestCsvView')->search(
        $search,
        $args,
    );
}

## ============================================================================
## The following methods are exclusively used when generating test result data
## suitable for graphing by jquery.flot:
## -------------------------------------
## Return the active list of columns for water tests or charting:
sub test_columns {
    my ( $self, $search ) = @_;


    my $cols = $self->schema->resultset('WaterTestParameterView')->search(
        $search,
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
