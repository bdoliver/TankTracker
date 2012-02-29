#!/bin/sh

## Quick & dirty to create / update modules from TankTracker database
## using DBIx::Class

LIB=$HOME/DEVEL/TankTracker/lib

perl -MDBIx::Class::Schema::Loader=make_schema_at,dump_to_dir:$LIB \
        -e 'make_schema_at("TankTracker::Schema",
                           { db_schema  => "public",
                             components => ["InflateColumn::DateTime"] },
                           [ "dbi:Pg:dbname=TankTracker", "brendon", undef ])'
