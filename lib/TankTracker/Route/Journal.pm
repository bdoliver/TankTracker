package TankTracker::Route::Journal;

use strict;

use Dancer               ':syntax';
use Dancer::Plugin::DBIC 'schema';

use TankTracker::Common::Utils qw(set_message
				  get_message
				  set_error
				  get_error
				  TIMEFMT);

prefix undef;

sub _get_tanks {
	my $tank_id   = shift;
	my $tanks     = {};

	my $resultSet = schema->resultset('Tank');

	while ( my $t = $resultSet->next() ) {
		$tanks->{$t->tank_id()} = { tank_id    => $t->tank_id(),
					    tank_name  => $t->tank_name(),
					    water_type => $t->water->water_type(),
					    selected   => ( $tank_id and $tank_id == $t->tank_id() )
							  ? 'SELECTED'
							  : undef };
	}
	return $tanks;
}

sub _get_water_types {
	my $types = {};

	my $resultSet = schema->resultset('WaterType');

	while ( my $w = $resultSet->next() ) {
		$types->{$w->water_id()} = { water_id   => $w->water_id(),
					     water_type => $w->water_type() };
	}
	return $types;
}

get '/journal' => sub {
	template 'journal.tt', { 'err'   => get_error(),
				 'msg'   => get_message(),
				 'tanks' => _get_tanks(),
				 'types' => _get_water_types(),
				};
};

post '/journal' => sub {
	my $tank_id = params->{'tank_id'};

	my $tt_args = { 
		'err'        => get_error(),
		'msg'        => get_message(),
		'tanks'      => _get_tanks($tank_id),
		'types'      => _get_water_types(),
	};

	if ( $tank_id ) {
		my $tank = schema->resultset('Tank')->find($tank_id);

		if ( $tank ) {
			$tt_args->{page_title}   = 'Journal';
			$tt_args->{tank_id}      = $tank_id;
			$tt_args->{tank_name}    = $tank->tank_name();
			$tt_args->{is_saltwater} = $tank->is_saltwater();
		}
	}

	template 'journal.tt', $tt_args;
};

1;
