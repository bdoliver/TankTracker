package TankTracker::Model::TankTest;

use strict;

use base qw(TankTracker::Model::Object);

__PACKAGE__->meta->setup(
    table   => 'tank_tests',

    columns => [
        test_id         => { type => 'serial', not_null => 1 },
        tank_id         => { type => 'integer', not_null => 1 },
        test_timestamp  => { type => 'timestamp', default => 'now()', not_null => 1 },
        result_sg       => { type => 'numeric' },
        result_ph       => { type => 'numeric' },
        result_nitrate  => { type => 'numeric' },
        result_nitrite  => { type => 'numeric' },
        result_ammonia  => { type => 'numeric' },
        result_calcium  => { type => 'numeric' },
        result_phospate => { type => 'numeric' },
        water_change    => { type => 'numeric' },
        notes           => { type => 'text' },
    ],

    primary_key_columns => [ 'test_id' ],

#    unique_key => [ 'tank_id' ],

    allow_inline_column_values => 1,

    foreign_keys => [
        tank => {
            class       => 'TankTracker::Model::Tank',
            key_columns => { tank_id => 'tank_id' },
            rel_type    => 'one to one',
        },
    ],
);

1;

