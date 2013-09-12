#!/bin/sh

## Quick & dirty to create / update modules from TankTracker database
## using DBIx::Class

LIB=$HOME/src/TankTracker/lib

perl -MDBIx::Class::Schema::Loader=make_schema_at,dump_to_dir:$LIB \
        -e 'make_schema_at("TankTracker::Schema",
                           { db_schema  => "public",
                             components => ["InflateColumn::DateTime"] },
                           [ "dbi:SQLite:dbname=$ENV{HOME}/src/TankTracker/db/TankTracker.db" ])'
#                           [ "dbi:Pg:dbname=TankTracker", "ebreoli", undef ])'
