package TankTracker::Model::WaterTest;

use strict;

use base qw(TankTracker::Model::Object);

__PACKAGE__->meta->setup(
    table   => 'water_tests',

    columns => [
        notes             => { type => 'text' },
        result_alkalinity => { type => 'numeric' },
        result_ammonia    => { type => 'numeric' },
        result_calcium    => { type => 'numeric' },
        result_kh         => { type => 'numeric' },
        result_magnesium  => { type => 'numeric' },
        result_nitrate    => { type => 'numeric' },
        result_nitrite    => { type => 'numeric' },
        result_ph         => { type => 'numeric' },
        result_phosphate  => { type => 'numeric' },
        result_salinity   => { type => 'numeric' },
        tank_id           => { type => 'integer', not_null => 1 },
        test_date         => { type => 'date', default => 'now' },
        test_id           => { type => 'serial', not_null => 1 },
        water_change      => { type => 'numeric' },
    ],

    primary_key_columns => [ 'test_id' ],

    foreign_keys => [
        tank => {
            class       => 'TankTracker::Model::Tank',
            key_columns => { tank_id => 'tank_id' },
        },
    ],
);

1;

