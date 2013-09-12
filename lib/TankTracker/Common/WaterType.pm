package TankTracker::Common::WaterType;

use strict;
use warnings;

use base qw(Exporter);

use Dancer::Plugin::DBIC 'schema';

our @EXPORT_OK = qw(watertype_list);

sub watertype_list {
    my $watertype_id = shift;
    my @watertypes   = ({ 'water_id'   => 0,
                          'water_type' => '-- Select type --' });

    my $resultSet    = schema->resultset('WaterType')
                             ->search(undef,
                                      { 'order_by' => 'water_id ASC' });

    while ( my $w = $resultSet->next() ) {
        push @watertypes, { 'water_id'   => $w->water_id(),
                            'water_type' => $w->water_type(),
                            'selected'   => ($watertype_id and $watertype_id == $w->water_id())
                                            ? 'SELECTED'
                                            : undef,
                          };
    }
    return \@watertypes;
}

1;
