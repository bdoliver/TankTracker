package TankTracker::Common::WaterTest;

use strict;
use warnings;

use base qw(Exporter);

use Dancer::Plugin::DBIC 'schema';
use File::Temp;
use IO::File;
use Text::CSV_XS;
use Tie::IxHash;

use TankTracker::Common::Diary qw(test_note);
use TankTracker::Common::Utils qw(START_PAGE
                                  REC_PER_PAGE
                                  build_gridSearch);

our @EXPORT_OK = qw(record_test
                    load_tests
                    test_results
                    test_history
                    export_tests
                    chart_data);

# Legend text & line colours for jquery.flot to use when charting test results:
our $ChartLegend = Tie::IxHash->new(
                    result_salinity   => { label  => 'Salinity',
                                           colour => '#7633BD' },
                    result_ph         => { label  => 'Ph',
                                           colour => '#A23C3C' },
                    result_ammonia    => { label  => 'NH<sub>4</sub>',
                                           colour => '#AFD8F8' },
                    result_nitrite    => { label  => 'NO<sub>2</sub>',
                                           colour => '#8CACC6' },
                    result_nitrate    => { label  => 'NO<sub>3</sub>',
                                           colour => '#BD9B33' },
                    result_calcium    => { label  => 'Ca',
                                           colour => '#CB4B4B' },
                    result_phosphate  => { label  => 'PO<sub>4</sub>',
                                           colour => '#3D853D' },
                    result_magnesium  => { label  => 'Mg',
                                           colour => '#9440ED' },
                    result_kh         => { label  => '<sup>0</sup>KH',
                                           colour => '#4DA74D' },
                    result_alkalinity => { label  => 'Alkalinity',
                                           colour => '#EDC240' },
);

sub record_test
{
    my $args    = shift or return undef;

    my $action  = delete $args->{action};
    my $test_id = delete $args->{test_id}; # will be undef when adding

    my $test;

    eval {
        if  ( $action eq 'add' ) {
            $test = schema->resultset('WaterTest')
                          ->create($args);
            $test or
                die "Failed to create new test object!";
        }
        else {
            $test_id or
                die "Cannot save test entry: missing parameter 'test_id'";

            $test = schema->resultset('WaterTest')
                          ->find($test_id);

            $test or
                die "Failed to load test record #$test_id from database";

            for my $attr ( $ChartLegend->Keys(), 'water_change' ) {
                my $val = $args->{$attr};

                $val = undef if ( defined $val and $val eq '' );

                $test->$attr($val);
            }
        }

        $test->update();  ## save (new or edited)
    };

    my $ret = {};

    if ( $@ ) {
        print STDERR "record_test() error: $@\n";

        $ret->{err} = "Error saving test results: $@";
    }
    else {
        $ret->{ok}  = 1;
    }

    return $ret;
}

sub test_results
{
    my $test_id = shift or return undef;

    my $test    = schema->resultset('WaterTest')->find($test_id);
    my $tank_id = $test->tank_id();
    my $tank    = schema->resultset('Tank')->find($tank_id);

    my $ret = { tank_name    => $tank->tank_name(),
                is_saltwater => $tank->is_saltwater() };

    for my $c ( $ChartLegend->Keys(), 'test_date' ) {
        my $val = $test->$c();

        $ret->{$c} = ( $c eq 'test_date' )
                        ? $val->ymd()
                        : $val;
    }

    return $ret;
}

sub test_history
{
    my $args      = shift or return undef;

    my $tank_id   = $args->{tank_id};
    my $sdate     = $args->{sdate};
    my $edate     = $args->{edate};
    my $chart     = $args->{chart};
    my $all_tanks = $args->{all_tanks};

    my $query     = build_gridSearch($args);

    if ( ! $all_tanks ) {
        $tank_id or return undef;  # must have tank_id 

        if ( ! $query->{'-and'} ) {
            $query->{'-and'} = [ 'me.tank_id' => $tank_id ];
        }
        else {
            push @{ $query->{'-and'} }, [ 'me.tank_id' => $tank_id ];
        }
    }
    else {
        # all_tanks selected for export:
        $query->{'-and'} = [ ];
    }

    push @{ $query->{'-and'} }, [ 'test_date' => { '>=', $sdate } ] if $sdate;
    push @{ $query->{'-and'} }, [ 'test_date' => { '<=', $edate } ] if $edate;

    my $sort_col = $args->{sidx} || 'me.test_id';
    my $sort_dir = $args->{sord} || 'desc';
    my @joins    = ( 'tank' );
#     my $order_by = {};
# 
#     $order_by->{"-$sort_dir"} = [ $sort_col ];
# 
#     if ( $sort_col !~ m|tank_id| ) {
#         if ( exists $order_by->{"-asc"} ) {
#             unshift @{ $order_by->{"-asc"} }, "me.tank_id";
#         }
#         else {
#             $order_by->{"-asc"} = [ "me.tank_id" ];
#         }
#     }
    my $order_by = "$sort_col $sort_dir";

    $order_by = "me.tank_id asc, $order_by" if $sort_col !~ m|tank_id|;

    my @cols = ( $ChartLegend->Keys(),
                 'test_date' );

    $chart or push @cols, ('water_change',
                           'test_id',
                           'tank_name',
                           'tank_id' );

    if ( $args->{include_notes} ) {
        push @cols,  'test_notes';
        push @joins, 'tank_diary';
    }

    my @rows;

    my $rs = schema->resultset('WaterTest')
                   ->search($query,
                            { 'prefetch' => \@joins,
                              'order_by' => $order_by });

    while ( my $t = $rs->next() ) {
        my $test = {};

        for my $c ( @cols ) {
            my $val;

            if    ( $c eq 'tank_name'  ) {
                $val = $t->tank->tank_name();
            }
            elsif ( $c eq 'test_notes' ) {
                $val = $t->tank_diary()
                       ? $t->tank_diary->diary_note()
                       : '';
            }
            else {
                $val = $t->$c;
            }

            if ( $c eq 'test_date' ) {
                # test_date is a DateTime object, but
                # jquery.flot.js requires date as 
                # epoch time milliseconds.. otherwise
                # format as yyyy-mm-dd:
                $val = $chart
                       ? $val->epoch() * 1000
                       : $val->ymd();
            }
#             elsif ( $chart and ! $args->{$c} ) {
#                     next;  ## ignore column not requested for charting
#             }

            $test->{$c} = $val; # || 0;
        }
        push @rows, $test;
    }

    return \@rows;
}

## Munge test_results() into a format useable by jquery.flot.js:
sub chart_data
{
    my $args = shift or return undef;

    $args->{chart}++;

    my $tests = test_history($args);

## Example flot data series:
# {
#    "label": "Europe (EU27)",
#    "data": [[1999, 3.0], [2000, 3.9], [2001, 2.0], [2002, 1.2], [2003, 1.3]]
# }
    my ( %data, $axis );

    for my $test ( @$tests ) {
        my $test_date = $test->{test_date};

        # Not interested in charting these values:
        map { delete $test->{$_} } qw(test_id
                                      tank_id
                                      test_date
                                      notes
                                      water_change);

        for my $parameter ( keys %$test ) {
            # Ignore parameter which was not requested for charting:
            $args->{$parameter} or next;

            # Ignore potentially bogus parameter:
            $ChartLegend->EXISTS($parameter) or next;

            $data{$parameter} ||= { label => $ChartLegend->FETCH($parameter)->{label},
                                    color => $ChartLegend->FETCH($parameter)->{colour},
                                    xaxis => 1,
                                    yaxis => ++$axis,
                                    grid  => { hoverable => 1 },
                                    data  => [] };
            push @{ $data{$parameter}->{data} },
                    [ $test_date, $test->{$parameter} ];
        }
    }

    my @data;

    map { push @data, $data{$_} } sort keys %data;

    return \@data;
}

sub export_tests
{
    my $args = shift;

    $args->{sord} = 'asc';

    my $results = test_history($args) || [];

    my @cols = ( 'tank_id',
                 'tank_name',
                 'test_id',
                 'test_date',
                 $ChartLegend->Keys());

    push @cols, 'test_notes' if $args->{include_notes};

    my $fh  = File::Temp->new(UNLINK => 1,
                              DIR    => $args->{export_path});
    my $csv = Text::CSV_XS->new({ binary      => 1,
                                  sep_char    => q{,},
                                  quote_char  => q{"},
                                  escape_char => q{"},
                                  eol         => qq{\n},
                                  auto_diag   => 1 }) or
        die "Failed to create CSV object: $!\n";

    $csv->print($fh, \@cols);

    for my $rec ( @{ $results } ) {
        my @row = map { $rec->{$_} } @cols;

        $csv->print($fh, \@row);
    }

    return $fh;
}

sub load_tests
{
    my ( $fh, $delete ) = @_;

    if ( $delete ) {
        print STDERR "Deleting existing test results.\n";
        ## Clobber all existing test results...
        schema->resultset('WaterTest')
              ->search()
              ->delete();
    }

    $fh or return 0;

    if ( $fh eq '-' ) {
        ## reading from STDIN...
        $fh = IO::Handle->new();
        $fh->fdopen(fileno(STDIN), 'r') or
                    die "Cannot read STDIN: $!\n";
    }
    elsif ( -e $fh ) {
        ## reading from a named file...
        $fh = IO::File->new($fh, 'r') or
                    die "Cannot read $fh: $!\n";
    }
    elsif ( ref($fh) ) {
        ; # using IO::File/Handle object...
    }
    else {
        die "Cannot locate file=$fh for import!\n";
    }

    $fh or
        die "load_tests() aborting - no filehandle available for reading.\n";


    my $csv = Text::CSV_XS->new({ binary      => 1,
                                  sep_char    => q{,},
                                  quote_char  => q{"},
                                  escape_char => q{"},
                                  eol         => qq{\n},
                                  auto_diag   => 1 }) or
        die "Failed to create CSV object: $!\n";

    my ($attrs, $count);

    while ( my $row = $csv->getline($fh) ) {
        $row or die "CSV getline() did not return a row!\n";

        if ( ! $attrs and scalar grep(/tank_id/i, @$row) ) {
            $attrs = $row;
            next;
        }

        my %test;

        @test{@$attrs} = @$row;

        #print "Test:\n", Dumper(\%test);
        ++$count if record_test(\%test);
    }

    return $count;
}

1;
