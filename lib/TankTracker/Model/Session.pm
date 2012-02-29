package TankTracker::Model::Session;

use strict;

use base qw(TankTracker::Model::Object);

__PACKAGE__->meta->setup(
    table   => 'session',

    columns => [
        session_id => { type => 'bigint', not_null => 1 },
        created_on => { type => 'timestamp', not_null => 1 },
    ],

    primary_key_columns => [ 'session_id' ],
);

1;

