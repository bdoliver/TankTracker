package TankTracker::Journal;

use strict;

use Dancer ':syntax';

use TankTracker::Model::Tank;
use TankTracker::Model::Tank::Manager;
use TankTracker::Model::WaterType::Manager;
use TankTracker::Utils qw(set_message
		          get_message
		          set_error
		          get_error);

prefix undef;

sub _get_tanks {
	my $tank_id   = shift;
	my $tanks     = {};
	my $tank_aref = TankTracker::Model::Tank::Manager->get_tank(with_objects => [ 'water_type' ]);

	for my $t ( @$tank_aref ) {
		$tanks->{$t->tank_id()} = { tank_id    => $t->tank_id(),
					    tank_name  => $t->tank_name(),
					    water_type => $t->water_type->water_type(),
					    selected   => ( $tank_id and $tank_id == $t->tank_id() )
							  ? 'SELECTED'
							  : undef };
	}
	return $tanks;
}

sub _get_water_types {
	my $types = {};

	my $types_aref = TankTracker::Model::WaterType::Manager->get_water_type();

	for my $t ( @$types_aref ) {
		$types->{$t->water_id()} = { water_id   => $t->water_id(),
					     water_type => $t->water_type() };
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
		my $tank = TankTracker::Model::Tank->new(tank_id => $tank_id);

		$tank->load();
		$tt_args->{page_title}   = 'Journal';
		$tt_args->{tank_id}      = $tank_id;
		$tt_args->{tank_name}    = $tank->tank_name();
		$tt_args->{is_saltwater} = $tank->is_saltwater();
	}

	template 'journal.tt', $tt_args;
};

1;
