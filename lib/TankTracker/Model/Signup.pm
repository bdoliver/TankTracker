package TankTracker::Model::Signup;

use strict;

use JSON::WebToken;
use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'Signup',
);

sub get {
    my ( $self, $hash ) = @_;

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

sub add {
    my ( $self, $email ) = @_;


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
        die $_;
    };

    return $self->deflate($tank);
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
