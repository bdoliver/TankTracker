package TankTracker::Route::WaterTest;

use strict;

use Dancer               ':syntax';
use Dancer::Plugin::DBIC 'schema';

use Tie::IxHash;

use TankTracker::Common::Diary qw(save_diary);

use TankTracker::Common::Utils qw(set_message
				  get_message
				  set_error
				  get_error
				  TIMEFMT);

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

prefix '/test';

sub _test_results
{
	my $args = shift;

	my $tank_id = $args->{tank_id};
	my $sdate   = $args->{sdate};
	my $edate   = $args->{edate};
	my $chart   = $args->{chart};

	my $query = { '-and' => [ 'tank_id' => $tank_id ] };

	push @{ $query->{'-and'} }, [ 'test_date' => { '>=', $sdate } ] if $sdate;
	push @{ $query->{'-and'} }, [ 'test_date' => { '<=', $edate } ] if $edate;

	my $resultSet = schema->resultset('WaterTest')->search($query,
							       { 'order_by' => 'test_date DESC' });

	my @tests = ();

	my $idx;

	while ( my $t = $resultSet->next() ) {
		my $test = {};

		for my $c ( $ChartLegend->Keys(), 'test_date' ) {
			my $val = $t->$c;
			if ( $c eq 'test_date' ) {
				if ( ! $chart ) {
					# test_date is a DateTime object, so
					# reformat to display as yyyy-mm-dd:
					$val = $val->ymd();
				}
				else {
					# jquery.flot.js requires date
					# in epoch milliseconds:
					$val = $val->epoch() * 1000;
				}
			}
			elsif ( $chart and ! $args->{$c} ) {
				next;  ## ignore column not requested for charting
			}
			$test->{$c} = $val || 0;
		}
		push @tests, $test;
	}

	return \@tests;
}

## Munge test_results() into a format useable by jquery.flot.js:
sub _chart_data
{
	my $args = shift;

	$args->{chart}++;

	my $tests = _test_results($args);

## Example flot data series:
# {
#    "label": "Europe (EU27)",
#    "data": [[1999, 3.0], [2000, 3.9], [2001, 2.0], [2002, 1.2], [2003, 1.3]]
#}
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

## GET = grab details of an exist test's results:
get '/' => sub {
	my $test_id = params->{'test_id'};
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
	for my $attr ( $ChartLegend->Keys(), 'water_change' ) {
		if ( defined $test{$attr} and $test{$attr} eq '' ) {
			$test{$attr} = undef;
		}
	}

	my $test = schema->resultset('WaterTest')->create(\%test);

	eval { $test->update(); };

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

	# returns JSON, not a template:
	return $ret;
};

get '/history' => sub {
	my $tank_id = params->{'tank_id'};
	my $tank    = schema->resultset('Tank')->find($tank_id);

	my $tt_args = {
		'tank_id'      => $tank_id,
		'is_saltwater' => $tank->is_saltwater(),
		'tests'        => _test_results({tank_id => $tank_id}) 
	};

	template 'testHistory.tt', $tt_args, { layout => undef };
};


## Request for tests Chart page:
get '/chart' => sub {
	my $tank_id = params->{'tank_id'};
	my $tank    = schema->resultset('Tank')->find($tank_id);

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
