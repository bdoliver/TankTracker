package TankTracker::Model::TankDiary;

use strict;

use base qw(TankTracker::Model::Object);

__PACKAGE__->meta->setup(
    table   => 'tank_diary',

    columns => [
        diary_date => { type => 'timestamp', not_null => 1 },
        diary_id   => { type => 'serial', not_null => 1 },
        diary_note => { type => 'text', not_null => 1 },
        tank_id    => { type => 'integer', not_null => 1 },
        test_id    => { type => 'integer' },
        updated_on => { type => 'timestamp', default => 'now' },
    ],

    primary_key_columns => [ 'diary_id' ],

    foreign_keys => [
        tank => {
            class       => 'TankTracker::Model::Tank',
            key_columns => { tank_id => 'tank_id' },
        },

        water_tests => {
            class       => 'TankTracker::Model::WaterTests',
            key_columns => { test_id => 'test_id' },
        },
    ],
);

1;

