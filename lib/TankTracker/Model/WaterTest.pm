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

# # $WaterTest_attributes:
# #      label + color: used by jquery.flot when charting test results
# #      title: used when rendering the test results table
# our $WaterTest_attributes = Hash::Ordered->new(
#     test_id => {
#         title => 'Test Id',
#     },
#     tank_id => {
#         title => 'Tank Id',
#         hide  => 1, # don't show in list table
#     },
#     user_id => {
#         title => 'User Id',
#         hide  => 1, # don't show in list table
#     },
#     test_date => {
#         title => 'Test Date',
#     },
#     temperature => {
#         title => 'Temperature',
#         label => 'Temperature',
#         color => '#FFFFFF',
#     },
#     water_change => {
#         title => 'Water Change',
#     },
# # Notes will require some client-side javascript to make available:
# #     notes => {
# #         title => 'Notes',
# #     },
#     result_salinity   => {
#         title => 'Salinity',
#         label => 'Salinity',
#         color => '#7633BD',
#     },
#     result_ph => {
#         title => 'Ph',
#         label => 'Ph',
#         color => '#A23C3C',
#     },
#     result_ammonia => {
#         title => 'Ammonia<br />(NH<sub>4</sub>)',
#         label => 'NH<sub>4</sub>',
#         color => '#AFD8F8',
#     },
#     result_nitrite => {
#         title => 'Nitrite<br />NO<sub>2</sub>)',
#         label => 'NO<sub>2</sub>',
#         color => '#8CACC6',
#     },
#     result_nitrate => {
#         title => 'Nitrate<br />(NO<sub>3</sub>)',
#         label => 'NO<sub>3</sub>',
#         color => '#BD9B33',
#     },
#     result_calcium => {
#         label => 'Ca',
#         color => '#CB4B4B',
#     },
#     result_phosphate => {
#         title => 'Phosphate<br />PO<sub>4</sub>)',
#         label => 'PO<sub>4</sub>',
#         color => '#3D853D',
#     },
#     result_magnesium => {
#         title => 'Magnesium<br />(Mg)',
#         label => 'Mg',
#         color => '#9440ED',
#     },
#     result_kh => {
#         title => 'Carbonate<br />Hardness<br />(&deg;KH)',
#         label => '&deg;KH',
#         color => '#4DA74D',
#     },
#     result_alkalinity => {
#         title => 'Alkalinity',
#         label => 'Alkalinity',
#         color => '#EDC240',
#     },
# );

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
use Data::Dumper;
warn "\n\n update details:\n", Dumper($details);
warn "\n\n update results:\n", Dumper($results);
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
    my $diary = delete $test->{'diary'};

    $test->{'notes'} = $diary->{'diary_note'} if $diary;

    my $results = delete $test->{'water_test_results'} || [];

    for my $result ( @{ $results } ) {
        my $param_id = $result->{'parameter_id'};

        $test->{'tank_id'} ||= $result->{'tank_id'};
        $test->{"test_result_$param_id"} = $result->{'test_result_id'};
        $test->{"parameter_$param_id"}   = $result->{'test_result'};
    }

    return $test;
}

## We override the Base class' list() method because we need to munge
## the test results into something more useful. It also saves us from
## having to have the ugly search criteria for tank_id (which is on the
## water_test_result record (NOT the water_test record); AND the ugly
## prefetch crap we need to make sure we get all the col headings & notes.
sub list {
    my ( $self, $search, $args ) = @_;

    # in case we get passed nothing, we will attempt to return
    # sane stuffs...
    $search ||= {};
    $args   ||= {};

    if ( my $tank_id = delete $search->{'tank_id'} ) {
        $search->{'water_test_results.tank_id'} = $tank_id;
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

    my ( $rows, $pager ) = @{ $self->SUPER::list($search,$args) };

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

    return [ $rows, $pager ];
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

## NB: load_tests() is expected to be called within an eval{} or
##     try/catch block in order to simplify error reporting to the
##     caller.
sub load_tests {
    my ( $self, $args ) = @_;

    for my $arg ( qw( tank_id user_id fh ) ) {
        $args->{$arg} or
        die qq{load_tests() missing '$arg' parameter!};
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

## ============================================================================
## The following methods are exclusively used when generating test result data
## suitable for graphing by jquery.flot:
## -------------------------------------
sub chart_columns {
#    return [ grep { $_ =~ qr{^result_} } $WaterTest_attributes->keys() ];
}

sub chart_legend {
    my ( $self, $col ) = @_;

    $col or die "chart_legend() missing argument!";

    my $legend = ''; #$WaterTest_attributes->get($col);

    return { map { $_ => $legend->{$_} } (qw(label color)) };
}

sub chart_data {
    my ( $self, @args ) = @_;

    # chart_data() is always passed an attributes hashref,
    # so the following is safe.  We don't want to deflate
    # the resultset into a hashref.  We need the test_date
    # as an inflated DateTime object so that we can get its
    # epoch seconds (required by jquery.flot's time series):
    $args[1]{'no_deflate'} = 1;

    my $tests = $self->list(@args);

    my %results = ();
    my $axis    = 0;

    my %want_col;

    ## massage test results into format required for charting.

    ## the order of @cols from the web page is not deterministic,
    ## so we process the requested fields in a fixed order which
    ## matches the checkboxes on the chart page:
    my @cols = grep { $_ ne 'notes' } @{ $args[1]{'columns'} };

    my $want_notes = grep { $_ eq 'notes' } @{ $args[1]{'columns'} };

    @want_col{@cols} = ( 1 ) x @cols;

    my $chart_cols = $self->chart_columns();

    while ( my $rec = $tests->next() ) {
        for my $col ( @{ $chart_cols } ) {

            # skip columns which were not requested:
            $want_col{$col} or next;

            $results{$col} ||= {
                %{ $self->chart_legend($col) },
                'xaxis' => 1,
                'yaxis' => ++$axis,
                'grid'  => { 'hoverable' => 1 },
                'data'  => [],
            };

            my $row_data = [
                # NB: jquery.flot.js requires date
                #     as epoch time in milliseconds:
                $rec->test_date->epoch() * 1000,
                $rec->$col()
            ];

            push @$row_data, $rec->notes() if $want_notes;

            push @{ $results{$col}{'data'} }, $row_data;
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
