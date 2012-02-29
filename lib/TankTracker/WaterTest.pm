package TankTracker::WaterTest;

use strict;

use Dancer ':syntax';

use DateTime;
use DateTime::Format::Pg;

use TankTracker::Model::Tank;
use TankTracker::Model::WaterTest;
use TankTracker::Model::WaterTest::Manager;

use TankTracker::Utils qw(set_message
		          get_message
		          set_error
		          get_error
		          TIMEFMT);

# Long-form names don't really fit in jquery.flot's chart legend:
# our $ChartLegend = {  result_salinity   => 'Specific Gravity',
		      # result_ph         => 'Ph',
		      # result_ammonia    => 'Ammonia',
		      # result_nitrite    => 'Nitrite',
		      # result_nitrate    => 'Nitrate',
		      # result_calcium    => 'Calcium',
		      # result_phosphate  => 'Phosphate',
		      # result_magnesium  => 'Magnesium',
		      # result_kh         => 'dKH',
		      # result_alkalinity => 'Alkalinity' };
# Briefer / HTML-friendly legend names:
our $ChartLegend = {  result_salinity   => 'Salinity',
		      result_ph         => 'Ph',
		      result_ammonia    => 'NH<sub>4</sub>',
		      result_nitrite    => 'NO<sub>2</sub>',
		      result_nitrate    => 'NO<sub>3</sub>',
		      result_calcium    => 'Ca',
		      result_phosphate  => 'PO<sub>4</sub>',
		      result_magnesium  => 'Mg',
		      result_kh         => '<sup>0</sup>KH',
		      result_alkalinity => 'Alkalinity' };

prefix '/test';

sub _test_results
{
	my $args = shift;

	my $tank_id = $args->{tank_id};
	my $sdate   = $args->{sdate};
	my $edate   = $args->{edate};
	my $chart   = $args->{chart};

	my $query   = [ tank_id => $tank_id ];

	push @$query, ( test_date => { ge => $sdate } ) if $sdate;
	push @$query, ( test_date => { le => $edate } ) if $edate;

	my %query = ( query   => $query,
		      sort_by => 'test_date DESC' );

	my $tests = TankTracker::Model::WaterTest::Manager->get_water_tests(%query);
	my %tests = ();

	if ( $tests and @$tests ) {
		my @cols = $tests->[0]->meta()->column_names();
		my $idx;
		for my $t ( @$tests ) {
			my $test = {};
			for my $c ( @cols ) {
				my $val = $t->$c;
				if ( $c eq 'test_date' ) {
					if ( ! $chart ) {
						# test_date is a DateTime object, so
						# reformat to display as yyyy-mm-dd:
						#$val = scalar $val;
						#$val =~ s/T\d\d:\d\d:\d\d$//;
						$val = $val->ymd();
					}
					else {
						# jquery.flot.js requires date
						# in epoch seconds:
						$val = $val->epoch() * 1000;
					}
				}
				elsif ( $chart and ! $args->{$c} ) {
					next;  ## ignore column not requested for charting
				}
				$test->{$c} = $val || 0;
			}
			$tests{++$idx} = $test;
		}
	}

	return \%tests;
}

## Munge test_results() into a format useable by jquery.flot.js:
sub _chart_data
{
	my $args = shift;

	$args->{chart}++;

	my $results = _test_results($args);

## Example flot data series:
# {
#    "label": "Europe (EU27)",
#    "data": [[1999, 3.0], [2000, 3.9], [2001, 2.0], [2002, 1.2], [2003, 1.3]]
#}
	my ( %data, $axis );

	for my $id ( sort { $b <=> $a } keys %$results ) {
		my $test      = $results->{$id};
		my $test_date = $test->{test_date};

		# Not interested in charting these values:
		delete $test->{test_id};
		delete $test->{tank_id};
		delete $test->{test_date};
		delete $test->{notes};
		delete $test->{water_change};

		for my $parameter ( keys %$test ) {
			# Ignore parameters which were not requested for charting:
			$args->{$parameter} or next;

			$data{$parameter} ||= { label => $ChartLegend->{$parameter},
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

## GET = grab details of an exist test's results:
get '/' => sub {
	my $test_id = params->{'test_id'};
	my $test    = TankTracker::Model::WaterTest->new(test_id => $test_id);

	$test->load();

	my $tank_id = $test->tank_id();
	my $tank    = TankTracker::Model::Tank->new(tank_id => $tank_id);

	$tank->load();

	my @cols = $test->meta()->column_names();

	my $ret = { tank_name    => $tank->tank_name(),
		    is_saltwater => $tank->is_saltwater() };


	for my $c ( @cols ) {
		my $val = $test->$c();

		$ret->{$c} = ( ref($val) eq 'DateTime' )
			     ? $val->ymd()
			     : $val;
	}

	# returns JSON, not a template:
	return $ret;
};

## POST = saving a new test, or saving an edited test
post '/' => sub {
	my %test = ( tank_id           => params->{tank_id},
		     test_date         => params->{test_date},
		     result_salinity   => params->{test_salinity},
		     result_ph         => params->{test_ph},
		     result_ammonia    => params->{test_ammonia},
		     result_nitrite    => params->{test_nitrite},
		     result_nitrate    => params->{test_nitrate},
		     result_calcium    => params->{test_calcium},
		     result_phosphate  => params->{test_phosphate},
		     result_magnesium  => params->{test_magnesium},
		     result_kh         => params->{test_kh},
		     result_alkalinity => params->{test_alkalinity},
		     water_change      => params->{water_change},
		     notes             => params->{test_notes}, 
		   );

	# Record insertion will barf if we try to put an empty string
	# into a numeric field, so we explicitly nullify them:
	# (if a test result is zero, we want zero - not 'null' - so don't
	#  replace emptry string with zero)
	for my $attr ( keys %{ $ChartLegend }, 'water_change' ) {
		if ( defined $test{$attr} and $test{$attr} eq '' ) {
			$test{$attr} = undef;
		}
	}

	my $test = TankTracker::Model::WaterTest->new(%test);

	eval { $test->save(); };

	my $ret = {};

	if ( $@ ) {
		$ret->{err} = "Error saving test record: $@";
	}
	else {
		## also create a diary note for the test:
		my $args = { tank_id    => params->{tank_id},
			     action     => 'add',
			     diary_note => 'Water test.' };

		$ret = save_diary($args);
	}

	# POST only via Ajax, so return Ajax:
	return $ret;
};

get '/history' => sub {
	my $tank_id = params->{'tank_id'};
	my $tank    = TankTracker::Model::Tank->new(tank_id => $tank_id);

	$tank->load();

	my $tt_args = {
		'tank_id'      => $tank->tank_id(),
		'is_saltwater' => $tank->is_saltwater(),
		'tests'        => _test_results({tank_id => $tank_id}) 
	};

	template 'testHistory.tt', $tt_args, { layout => undef };
};


## Request for tests Chart page:
get '/chart' => sub {
	my $tank_id = params->{'tank_id'};
	my $tank    = TankTracker::Model::Tank->new(tank_id => $tank_id);

	$tank->load();

	my $tt_args = { tank_id      => $tank_id,
			is_saltwater => $tank->is_saltwater() };

	template 'testChart.tt', $tt_args, { layout => undef };
};

## Request for test data for Charting:
post '/chart' => sub {
	my $results = _chart_data({ tank_id           => params->{'tank_id'},
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

	return $results;
};

1;