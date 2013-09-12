package TankTracker::Route::WaterTest;

use strict;
use warnings;

use Dancer ':syntax';

use TankTracker::Common::Tank  qw(get_tank);
use TankTracker::Common::Utils qw(set_message
                                  get_message
                                  set_error
                                  get_error
                                  paginate
                                  START_PAGE
                                  REC_PER_PAGE
                                  TIMEFMT);
use TankTracker::Common::WaterTest qw(record_test
                                      test_results
                                      load_tests
                                      test_history
                                      export_tests
                                      chart_data);

prefix '/test';

## GET = grab details of an existing test's results:
get '/' => sub {
    # returns JSON, not a template:
    return test_results(params->{'test_id'});
};

## POST = saving a new test, or saving an edited test
post '/' => sub {
    my %params = params;

    my $op = $params{oper} or
                die "POST /test failed - no 'oper' param!\n";

    ## jqGrid gives 'oper', but I prefer 'action':
    $params{action} = delete $params{oper};

    ## remove unwanted parameters:
    delete $params{splat};
    delete $params{id};

    return record_test(\%params);
};

## Request for test results from jqGrid
get '/results' => sub {
    my %params = params;

    return paginate({name => 'tests',
                     recs => test_history(\%params),
                     page => $params{page},
                     rows => $params{rows}});
};

## Request for tests Chart page:
get '/chart' => sub {
    my $tank    = get_tank(params->{'tank_id'});
    my $tt_args = { tank_id      => $tank->tank_id(),
                    is_saltwater => $tank->is_saltwater() };

    template 'testChart.tt', $tt_args, { layout => undef };
};

## Request for test data for Charting:
post '/chart' => sub {
    return chart_data({ tank_id           => params->{'tank_id'},
                        sdate             => params->{'sdate'},
                        edate             => params->{'edate'},
                        result_ph         => params->{'chart_ph'},
                        result_salinity   => params->{'chart_salinity'},
                        result_ammonia    => params->{'chart_ammonia'},
                        result_nitrite    => params->{'chart_nitrite'},
                        result_nitrate    => params->{'chart_nitrate'},
                        result_calcium    => params->{'chart_calcium'},
                        result_phosphate  => params->{'chart_phosphate'},
                        result_magnesium  => params->{'chart_magnesium'},
                        result_kh         => params->{'chart_kh'},
                        result_alkalinity => params->{'chart_alkalinity'},
                      });
};

post '/upload' => sub {
    my $upload = upload('test_data');

    print STDERR "Upload content-type: ", $upload->type(), "\n";

    load_tests($upload->file_handle());

    #LOG: "Loaded $count test results\n";
};

## GET tools page...
get '/tools' => sub {
    my $tank    = get_tank(params->{'tank_id'});
    my $tt_args = { tank_id      => $tank->tank_id(),
                    is_saltwater => $tank->is_saltwater() };

    template 'testTools.tt', $tt_args, { layout => undef };
};

post '/export' => sub {
    my %p = params;

    my $pubdir = Dancer::Config::setting('public');

    $p{export_path} = "$pubdir/export";

    my $fh = export_tests(\%p);

    ## Must strip the dir prefix, as send_file() expects the $file argument
    ## to be RELATIVE to the Dancer /public dir....
    ## If we don't do this, Dancer will blow up with an extremely cryptic 
    ## error.
    my $file = $fh->filename();

    $file =~ s|^$pubdir||;

    return send_file ($file,
                      'content_type' => "text/$p{export_format}",
                      'filename'     => "test_results.$p{export_format}",
                      'streaming'    => 1);
};

1;
