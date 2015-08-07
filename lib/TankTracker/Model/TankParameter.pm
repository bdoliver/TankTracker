package TankTracker::Model::TankParameter;

use strict;

use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'TankParameter',
);

sub update {
    my ( $self, $params ) = @_;

    $params or return 1;

    try {
        ref($params) eq 'ARRAY'
            or die "TankParameter::update() requires arrayref of paramaters\n";

        for my $param ( @{ $params } ) {
            $self->resultset->update_or_create($param);
        }
    }
    catch {
        die $_;
    };

    return 1;
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
