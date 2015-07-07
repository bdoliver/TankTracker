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

# $WaterTest_attributes:
#      label + color: used by jquery.flot when charting test results
#      title: used when rendering the test results table
our $WaterTest_attributes = Hash::Ordered->new(
    test_id => {
        title => 'Test Id',
    },
    tank_id => {
        title => 'Tank Id',
        hide  => 1, # don't show in list table
    },
    user_id => {
        title => 'User Id',
        hide  => 1, # don't show in list table
    },
    test_date => {
        title => 'Test Date',
    },
    temperature => {
        title => 'Temperature',
        label => 'Temperature',
        color => '#FFFFFF',
    },
    water_change => {
        title => 'Water Change',
    },
# Notes will require some client-side javascript to make available:
#     notes => {
#         title => 'Notes',
#     },
    result_salinity   => {
        title => 'Salinity',
        label => 'Salinity',
        color => '#7633BD',
    },
    result_ph => {
        title => 'Ph',
        label => 'Ph',
        color => '#A23C3C',
    },
    result_ammonia => {
        title => 'Ammonia<br />(NH<sub>4</sub>)',
        label => 'NH<sub>4</sub>',
        color => '#AFD8F8',
    },
    result_nitrite => {
        title => 'Nitrite<br />NO<sub>2</sub>)',
        label => 'NO<sub>2</sub>',
        color => '#8CACC6',
    },
    result_nitrate => {
        title => 'Nitrate<br />(NO<sub>3</sub>)',
        label => 'NO<sub>3</sub>',
        color => '#BD9B33',
    },
    result_calcium => {
        label => 'Ca',
        color => '#CB4B4B',
    },
    result_phosphate => {
        title => 'Phosphate<br />PO<sub>4</sub>)',
        label => 'PO<sub>4</sub>',
        color => '#3D853D',
    },
    result_magnesium => {
        title => 'Magnesium<br />(Mg)',
        label => 'Mg',
        color => '#9440ED',
    },
    result_kh => {
        title => 'Carbonate<br />Hardness<br />(&deg;KH)',
        label => '&deg;KH',
        color => '#4DA74D',
    },
    result_alkalinity => {
        title => 'Alkalinity',
        label => 'Alkalinity',
        color => '#EDC240',
    },
);

sub fields {
    return [ $WaterTest_attributes->keys() ];
}

sub attributes {
    return { $WaterTest_attributes->as_list() };
}

sub add {
    my ( $self, $params ) = @_;

    my $test = $self->resultset->create($params);

    $self->add_diary({
        'tank_id'    => $test->tank_id(),
        'user_id'    => $test->user_id(),
        'diary_note' => 'Added water test results',
        'test_id'    => $test->test_id(),
    });

    return $self->deflate($test);
}

sub update {
    my ( $self, $test_id, $params ) = @_;

    my $test = $self->resultset->find($test_id);

    $test->update($params);

    $self->add_diary({
        'tank_id'    => $test->tank_id(),
        'user_id'    => $params->{'user_id'},
        'diary_note' => 'Updated water test results',
        'test_id'    => $test_id,
    });

    return $self->deflate($test);
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
    return [ grep { $_ =~ qr{^result_} } $WaterTest_attributes->keys() ];
}

sub chart_legend {
    my ( $self, $col ) = @_;

    $col or die "chart_legend() missing argument!";

    my $legend = $WaterTest_attributes->get($col);

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
