package TankTracker::Common::Inventory;

use strict;
use warnings;

use base qw(Exporter);

use Dancer::Plugin::DBIC 'schema';

# use TankTracker::Common::Diary qw(save_diary test_note);
use TankTracker::Common::Utils qw(build_gridSearch);

our @EXPORT_OK = qw(inventory
                    save_inventory
                    inventory_types);

sub inventory {
    my $args = shift or return undef;

    my $tank_id  = $args->{tank_id};
    my $class_id = $args->{class_id};
    my $date     = $args->{date};

    ( $tank_id and $class_id ) or return [];

    my $query   = build_gridSearch($args);

    if ( ! $query->{'-and'} ) {
        $query->{'-and'} = [ 'me.tank_id'    => $tank_id,
                             'type.class_id' => $class_id ];
    }
    else {
        push @{ $query->{'-and'} }, [ 'me.tank_id'    => $tank_id,
                                      'type.class_id' => $class_id ];
    }

    push @{ $query->{'-and'} }, [ purchase_date => { '>=', $date } ] if $date;

    my $sort_col = $args->{sidx} || 'me.purchase_date';
    my $sort_dir = $args->{sord} || 'desc';

    my @rows;

    my $rs = schema->resultset('Inventory')
                   ->search($query,
                            { 'prefetch' => [ 'type' ],
                              'order_by' => "$sort_col $sort_dir" });

    while ( my $i = $rs->next() ) {
        push @rows, { item_id        => $i->item_id(),
                      tank_id        => $i->tank_id(),
                      user_id        => $i->user_id(),
                      type_id        => $i->type_id(),
                      type           => $i->type->type(),
                      description    => $i->description(),
                      purchase_date  => $i->purchase_date->ymd(),
                      purchase_price => $i->purchase_price(),
                      quantity       => $i->quantity()
                    };
    }

    return \@rows;
}

sub save_inventory {
    my $args = shift;

    my $action         = $args->{action};
    my $tank_id        = $args->{tank_id};
    my $user_id        = $args->{user_id};
    my $item_id        = $args->{item_id};
    my $type_id        = $args->{type_id};
    my $description    = $args->{description};
    my $purchase_date  = $args->{purchase_date};
    my $purchase_price = $args->{purchase_price};
    my $quantity       = $args->{quantity};

    my $inv;

    eval {
        if  ( $action eq 'add' ) {

            $inv = schema->resultset('Inventory')
                           ->create({tank_id        => $tank_id,
                                     user_id        => $user_id,
                                     type_id        => $type_id,
                                     description    => $description,
                                     purchase_date  => $purchase_date,
                                     purchase_price => $purchase_price,
                                     quantity       => $quantity});
            $inv or
                die "Failed to create new inventory object!";
        }
        else {
            $item_id or
                die "Cannot save diary entry: missing parameter 'item_id'";

            $inv = schema->resultset('Inventory')
                           ->find($item_id);

            $inv or
                die "Failed to load inventory record #$item_id from database";

            $inv->type_id($type_id);
            $inv->description($description);
            $inv->purchase_date($purchase_date);
            $inv->purchase_price($purchase_price);
            $inv->quantity($quantity);
        }

        $inv->update();  ## save (new or edited)
    };

    my $ret = {};

    if ( $@ ) {
        print STDERR "save_inventory() error: $@\n";

        $ret->{err} = "Error saving diary note: $@";
    }
    else {
        $ret->{ok}  = 1;
    }

    return $ret;

}

## This is intended for populating a <select> list of options,
## hence the use of generic 'id' and 'name' keys:
sub inventory_types {
    my $class_id = shift or return [];

    my $rs = schema->resultset('InventoryType')
                   ->search({ '-and'     => [ 'class_id' => $class_id ] },
                            { 'order_by' => "type_id asc" });

    my @rows = ( { 'id'   => 0,
                   'name' => '-- Select type --' } );

    while ( my $t = $rs->next() ) {
        push @rows, { id   => $t->type_id(),
                      name => $t->type() };
    }

    return \@rows;
}

1;
