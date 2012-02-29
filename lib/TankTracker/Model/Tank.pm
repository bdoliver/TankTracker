package TankTracker::Model::Tank;

use strict;

use base qw(TankTracker::Model::Object);

__PACKAGE__->meta->setup(
    table   => 'tank',

    columns => [
        notes      => { type => 'text' },
        tank_id    => { type => 'serial', not_null => 1 },
        tank_name  => { type => 'text', not_null => 1 },
        updated_on => { type => 'timestamp', default => 'now' },
        water_id   => { type => 'serial', not_null => 1 },
    ],

    primary_key_columns => [ 'tank_id' ],

    foreign_keys => [
        water_type => {
            class       => 'TankTracker::Model::WaterType',
            key_columns => { water_id => 'water_id' },
        },
    ],

    relationships => [
        tank_diary => {
            class      => 'TankTracker::Model::TankDiary',
            column_map => { tank_id => 'tank_id' },
            type       => 'one to many',
        },

        water_tests => {
            class      => 'TankTracker::Model::WaterTest',
            column_map => { tank_id => 'tank_id' },
            type       => 'one to many',
        },
    ],
);

sub is_saltwater
{
	my $self = shift;
	
	return ( $self->water_id() == 1 );
}

sub is_freshwater
{
	my $self = shift;

	return ! $self->is_saltwater();
}

1;

