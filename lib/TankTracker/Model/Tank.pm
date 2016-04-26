package TankTracker::Model::Tank;

use strict;

use Moose;
use Carp;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'Tank',
);

sub get {
    my ( $self, $id ) = @_;

    my $args = {
        'no_deflate' => 1,
        'prefetch'   => [
            'tank_water_test_parameters',
            'tank_photos',
        ],
        'join'       => 'last_water_test',
        '+select'    => [
            'last_water_test.last_test_date',
            'last_water_test.days_overdue'
        ],
        '+as'        => [
            'last_test_date',
            'days_overdue'
        ],
    };

    my $obj = $self->SUPER::get($id, $args);

    ## Calling deflate() on $obj doesn't walk the prefetched records,
    ## so we'll deflate those explicitly. We also put them into a consistent
    ## order while doing so.
    my @test_params = map { $self->deflate($_) }
                      sort { ( int($a->param_order()  || 0) <=> int($b->param_order()  || 0) )
                                                         or
                             ( int($a->parameter_id() || 0) <=> int($b->parameter_id() || 0) )
                           }
                      $obj->tank_water_test_parameters()->all();

    my @tank_photos = map { $self->deflate($_) }
                      sort { ( ($a->caption()   || '') cmp ($b->caption()   || '') )
                                                       or
                             ( ($a->file_name() || '') cmp ($b->file_name() || '') )
                           }
                      $obj->tank_photos()->all();

    my $tank = $self->deflate($obj);

    $tank->{test_params} = \@test_params;
    $tank->{photos}      = \@tank_photos;

    return $tank;
}

## Ensures we don't pass empty strings to the database for
## certain optional tank attributes:
sub _fix_params {
    my ( $self, $params ) = @_;

    for my $p ( qw( capacity length width depth active ) ) {
        $params->{$p} ||= 0;
    }

    return $params;
}

sub _water_test_params {
    my ( $self, $tank_id, $wtp ) = @_;

    if ( $wtp ) {
        my $rs = $self->schema->resultset('TankWaterTestParameter');

        for my $wtp ( @{ $wtp } ) {
            $wtp->{'tank_id'} = $tank_id;
            $rs->update_or_create($wtp);
        }
    }

    return 1;
}

sub update {
    my ( $self, $tank_id, $params, $wtp ) = @_;

    my $tank;

    if ( $wtp ) {
        ref($wtp) eq 'ARRAY' or
            croak "Tank::update() expected 3rd arg to be arrayref!\n";
    }

    try {
        $self->schema->txn_do(
            sub {
                $tank = $self->resultset->find($tank_id);

                $tank->update($self->_fix_params($params));

                # update water test parameters for this tank:
                $self->_water_test_params($tank_id, $wtp);
            }
        );

        $self->add_diary({
            'tank_id'    => $tank_id,
            'user_id'    => $tank->owner_id(),
            'diary_note' => 'Updated tank details',
        });
    }
    catch {
        croak $_;
    };

    return $self->deflate($tank);
}

sub add {
    my ( $self, $params, $wtp ) = @_;

    if ( $wtp ) {
        ref($wtp) eq 'ARRAY' or
            croak "Tank::add() expected 2rd arg to be arrayref!\n";
    }

    my $tank;

    try {
        $self->schema->txn_do(
            sub {
                $tank = $self->resultset->create($self->_fix_params($params));

                # set up water test parameters for this tank:
                $self->_water_test_params($tank->tank_id(), $wtp);

                # created a new tank record so create an access record for the user:
                $self->schema->resultset('TankUserAccess')->create({
                    'tank_id' => $tank->tank_id(),
                    'user_id' => $tank->owner_id(),
                    'admin'   => 1, # owner is always admin of their tank
                });
            }
        );

        $self->add_diary({
            'tank_id'    => $tank->tank_id(),
            'user_id'    => $tank->owner_id(),
            'diary_note' => 'Created tank',
        });
    }
    catch {
        croak $_;
    };

    return $self->deflate($tank);
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
