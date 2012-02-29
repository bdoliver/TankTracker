package TankTracker::Model::WaterType;

use strict;

use base qw(TankTracker::Model::Object);

__PACKAGE__->meta->setup(
    table   => 'water_type',

    columns => [
        water_id   => { type => 'serial', not_null => 1 },
        water_type => { type => 'text', not_null => 1 },
    ],

    primary_key_columns => [ 'water_id' ],

    relationships => [
        tank => {
            class      => 'TankTracker::Model::Tank',
            column_map => { water_id => 'water_id' },
            type       => 'one to many',
        },
    ],
);

1;

