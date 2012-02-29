package TankTracker::Route::Tank;

use strict;

use Dancer               ':syntax';
use Dancer::Plugin::DBIC 'schema';

use TankTracker::Common::Diary qw(save_diary);
use TankTracker::Common::Utils qw(set_message
				  get_message
				  set_error
				  get_error
				  pg_datetime
				  TIMEFMT);

prefix '/tank';

get '/' => sub {
	my $tank_id = params->{'tank_id'};

	my $tank    = schema->resultset('Tank')->find($tank_id);

	my $tt_args = { tank_id      => $tank_id,
			is_saltwater => $tank->is_saltwater(),
			updated_on   => $tank->updated_on()
					? $tank->updated_on()->strftime(TIMEFMT)
					: undef,
			notes        => $tank->notes() };

	template 'tank.tt', $tt_args, { layout => undef };
};

post '/' => sub {
	my $tank_id = params->{'tank_id'};

	my $tank    = schema->resultset('Tank')->find($tank_id);

	$tank->notes(params->{notes});
	$tank->updated_on(pg_datetime());

	eval { $tank->save(); };

	my $ret = {};

	if ( $@ ) {
		$ret->{err} = "Error saving notes: $@";
	}
	else {
		$ret->{ok} = 1;
		$ret->{updated_on} = $tank->updated_on()->strftime(TIMEFMT);

		# make a diary entry
		my $args = { tank_id    => $tank_id,
			     action     => 'add',
			     diary_note => 'Updated tank notes.' };

		# don't care if diary entry fails...
		save_diary($args);
	}

	# POST only via Ajax, so return Ajax:
	return $ret;
};

post '/add' => sub {
	my $tank_name = params->{'tankName'};
	my $tank_type = params->{'tankType'};

	if ( $tank_name and $tank_type ) {
		my $tank = schema->resultset('Tank')->create({tank_name => $tank_name,
							      water_id  => $tank_type});
		eval { $tank->update(); };
		if ( $@ ) {
			set_error("Error saving new tank: $@");
		}
		else {
			set_message("Saved new tank ok.");

			# Also create a new Diary entry:
			my $args = { tank_id    => $tank->tank_id(),
				     action     => 'add',
				     diary_note => 'Created new tank.' };

			# don't care if diary entry fails...
			save_diary($args);
		}
	}
	elsif ( ! $tank_name ) {
		set_error("Cannot add tank: missing tankName");
	}
	elsif ( ! $tank_type ) {
		set_error("Cannot add tank: missing tankType");
	}

	# back to the default page:
	redirect "/";
};

1;
