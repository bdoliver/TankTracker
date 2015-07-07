#!/bin/sh

## Quick & dirty to create / update modules from TankTracker database
## using DBIx::Class

# LIB=$HOME/src/catalyst/TankTracker/lib
#
# perl -MDBIx::Class::Schema::Loader=make_schema_at,dump_to_dir:$LIB \
#         -e 'make_schema_at("TankTracker::Schema",
#                            { db_schema  => "public",
#                              components => ["InflateColumn::DateTime"] },
#                             [ "dbi:Pg:dbname=TankTracker", undef, undef ])'

# ./tanktracker_create.pl model DB DBIC::Schema TankTracker::Schema \
#     create=static dbi:Pg:dbname=TankTracker

./tanktracker_create.pl model TankTracker DBIC::Schema TankTracker::Schema \
    create=static dbi:Pg:dbname=TankTracker
