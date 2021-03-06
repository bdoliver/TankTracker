#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;

use DBIx::Class::Schema::Loader qw(make_schema_at);

print "#>>> refreshing DBIx::Class::Schema...\n\n";
make_schema_at(
    'TankTracker::Schema',
    {
        use_namespaces          => 0,
        skip_relationships      => 0,
        debug                   => 0,
        dump_directory          =>  "$FindBin::Bin/../lib",
        naming                  => 'current',
        overwrite_modifications => 1,
        generate_pod            => 0,
        exclude                 => qr{^_.*},
        db_schema               => [ '%' ],
        moniker_parts           => [ 'name' ],
        # NB: 'user' is a reserved word in PostgreSQL and needs to be quoted
        # to avoid syntax errors.  Instead, we'll just re-map the
        # relationship name to something safer...
        rel_name_map            => { 'user' => 'tracker_user' },
        qualify_objects         => 1,
        components              => [ qw(InflateColumn::DateTime) ],
    },
    [
        "dbi:Pg:dbname=TankTracker", '', '', # use environment defaults
        {
           name_sep   => '.',
           quote_char => '"',
           AutoCommit => 1,
           RaiseError => 1,
        },
    ]
);
