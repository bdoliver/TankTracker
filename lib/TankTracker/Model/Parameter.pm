package TankTracker::Model::Parameter;

use strict;

use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'Parameter',
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
                        ## FIXME: log an error...
                        warn "update() parameter_id $param->{'parameter_id'} not found in database!\n";
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
        die $_;
    };

    return 1; # update() ok
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
