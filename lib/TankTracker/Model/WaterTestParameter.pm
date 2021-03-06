package TankTracker::Model::WaterTestParameter;

use strict;

use Moose;
use Carp;
use Log::Any qw($log);
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'WaterTestParameter',
);

## update() expects an array ref of hashrefs:
## [
##    { parameter_id => nn,
##      title        => 'xyz',
##      label        => 'abc',
##      rgb_colour   => '#ffffff',
##    },
##    ...
## ]
sub update {
    my ( $self, $params ) = @_;

    try {
        $self->schema->txn_do(
            sub {
                for my $param ( @$params ) {
                    my $row = $self->get($param->{'parameter_id'}, $self->no_deflate());

                    if ( ! $row ) {
                        $log->warn("WTP::update() parameter_id $param->{'parameter_id'} not found in database!");
                        next;
                    }
                    for my $col ( qw( title label rgb_colour ) ) {
                        # only update the attribute if it's present
                        #  and has changed:
                        if ( $param->{$col} and
                             $param->{$col} ne $row->$col() ) {
                            $row->$col($param->{$col});
                        }
                    }

                    # only save if something has changed...
                    $row->update() if $row->is_changed();
                }
            }
        );
    }
    catch {
        croak $_;
    };

    return 1; # update() ok
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
