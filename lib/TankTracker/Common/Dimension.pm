package TankTracker::Common::Dimension;

use strict;
use warnings;

use base qw(Exporter);

use Dancer::Plugin::DBIC 'schema';

our @EXPORT_OK = qw(dimension_list);

sub dimension_list {
    my $dimension_id = shift;
    my @dimesions    = ({ 'dimension_id'   => 0,
                          'dimension_desc' => '-- Units --' });

    my $resultSet    = schema->resultset('Dimension')
                             ->search(undef,
                                      { 'order_by' => 'dimension_id ASC' });

    while ( my $d = $resultSet->next() ) {
        push @dimesions, { 'dimension_id'   => $d->dimension_id(),
                           'dimension_desc' => $d->dimension_desc(),
                           'selected'       => ($dimension_id and $dimension_id == $d->dimension_id())
                                               ? 'SELECTED'
                                               : undef,
                         };
    }
    return \@dimesions;
}

1;
