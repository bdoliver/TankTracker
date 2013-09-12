package TankTracker::Common::Capacity;

use strict;
use warnings;

use base qw(Exporter);

use Dancer::Plugin::DBIC 'schema';

our @EXPORT_OK = qw(capacity_list);

sub capacity_list {
    my $capacity_id = shift;
    my @capacities  = ({ 'capacity_id'   => 0,
                         'capacity_desc' => '-- Units --' });

    my $resultSet   = schema->resultset('Capacity')
                            ->search(undef,
                                     { 'order_by' => 'capacity_id ASC' });

    while ( my $c = $resultSet->next() ) {
            push @capacities, { 'capacity_id'   => $c->capacity_id(),
                                'capacity_desc' => $c->capacity_desc(),
                                'selected'      => ($capacity_id and $capacity_id == $c->capacity_id())
                                                    ? 'SELECTED'
                                                    : undef,
                              };
    }
    return \@capacities;
}

1;
