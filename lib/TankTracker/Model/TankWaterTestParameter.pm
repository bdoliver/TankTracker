package TankTracker::Model::TankWaterTestParameter;

use strict;

use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'TankWaterTestParameter',
);

sub get_headings {
    my ( $self, $tank_id ) = @_;

    $tank_id or
        die "TankWaterTestParameter::get_headings() requires tank_id\n";

    my $rows = $self->list(
        {
            'tank_id' => $tank_id,
        },
        {
            'order_by' => { '-asc' => [ qw( param_order parameter_id ) ] },
        }
    );

    map { $_->{'col_align'} = 'right' } @{ $rows };

    unshift @{ $rows },
        {
            'title'     => 'Test ID',
            'col_align' => 'right',
            'active'    => 1,
        },
        {
            'title'     => 'Test Date',
            'col_align' => 'center',
            'active'    => 1,
        };

    push @{ $rows },
        {
            'title'     => 'Notes',
            'col_align' => 'left',
            'active'    => 1,
        };

    return $rows;
}

# sub update {
#     my ( $self, $params ) = @_;
#
#     $params or return 1;
#
#     try {
#         ref($params) eq 'ARRAY'
#             or die "TankParameter::update() requires arrayref of paramaters\n";
#
#         for my $param ( @{ $params } ) {
#             $self->resultset->update_or_create($param);
#         }
#     }
#     catch {
#         die $_;
#     };
#
#     return 1;
# }

no Moose;
__PACKAGE__->meta->make_immutable();

1;
