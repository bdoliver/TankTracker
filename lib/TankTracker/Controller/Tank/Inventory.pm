package TankTracker::Controller::Tank::Inventory;
use Moose;
use namespace::autoclean;

BEGIN { extends q{Catalyst::Controller::HTML::FormFu} }

with q{TankTracker::TraitFor::Controller::Tank};

=head1 NAME

TankTracker::Controller::Tank::Inventory - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{'page_title'} = 'Inventory';

    return 1;
}

sub _search_inventory {
    my ($self, $c) = @_;

    my $elements = [
        {
            name  => 'start_date',
            type  => 'Text',
        },
        {
            name  => 'end_date',
            type  => 'Text',
        },
        {
            name  => 'description',
            type  => 'Text',
        },
        {
            name  => 'inventory_type',
            type  => 'Select',
            empty_first       => 1,
            empty_first_label => '',
            options => [
                [ 'consumable'   => 'Consumable'   ],
                [ 'equipment'    => 'Equipment'    ],
                [ 'fish'         => 'Fish'         ],
                [ 'invertebrate' => 'Invertebrate' ],
                [ 'coral'        => 'Coral'        ],
            ],
        },
    ];

    return { elements => $elements };
}

sub list: Chained('get_tank') PathPart('inventory/list') FormMethod('_search_inventory') {
    my ($self, $c, $page, $column, $direction) = @_;

    $page      ||= 1;
    $column    ||= 'inventory_id',
    $direction ||= 'asc';

    my $tank_id = $c->stash->{'tank'}{'tank_id'};
    my $search  = {
        tank_id => $tank_id,
    };

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $params = $form->params();
        my @filter = ();

        if ( $params->{'start_date'} ) {
            push @filter,
                [ 'purchase_date' => { '>=', $params->{'start_date'} } ];
        };
        if ( $params->{'end_date'} ) {
            push @filter,
                [ 'purchase_date' => { '<=', $params->{'end_date'}   } ];
        };
        if ( $params->{'description'} ) {
            push @filter,
                [ 'description' => { 'ilike', sprintf('%%%s%%', $params->{'description'}) } ];
        };
        if ( $params->{'inventory_type'} ) {
            push @filter,
                [ 'inventory_type' => $params->{'inventory_type'} ];
        };

        $search->{'-and'} = \@filter if @filter;
    }

    my ( $inventory, $pager ) = @{ $c->model('Inventory')->list(
        $search,
        {
            order_by => { "-$direction" => $column },
            page     => $page,
            rows     => $c->stash->{'user'}{'preferences'}{'recs_per_page'} || 10,
        },
    ) };

    if ( $pager and ref($pager) ) {
        $pager->{'what'}      = 'inventory records';
        $pager->{'path'}      = [ '/tank', $tank_id, 'inventory/list', $page ];
        $pager->{'column'}    = $column;
        $pager->{'direction'} = $direction;
    }

    $c->stash->{'inventory'}      = $inventory;
    $c->stash->{'pager'}          = $pager;
    $c->stash->{'action_heading'} = 'Inventory';
    $c->stash->{'add_url'}        = qq{/tank/$tank_id/inventory/add};

    return 1;
}

sub add: Chained('get_tank') PathPart('inventory/add') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{'action_heading'} = 'Add Inventory';

    $c->forward('details');

    return;
}

sub get_inventory: Chained('get_tank') PathPart('inventory') CaptureArgs(1) {
    my ( $self, $c, $inventory_id ) = @_;

    if ( ! $inventory_id ) {
        ## Should never happen...
        my $error = q{missing inventory_id};
        $c->log->fatal("get_inventory() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( $inventory_id !~ qr{\A \d+ \z}msx ) {
        my $error = qq{invalid inventory_id '$inventory_id'};
        $c->log->fatal("get_inventory() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( my $item = $c->model('Inventory')->get($inventory_id) ) {
        if ( $item->{'tank_id'} != $c->stash->{'tank'}{'tank_id'} ) {
            my $error = qq{inventory item requested (#$inventory_id) does not belong to current tank!};
            $c->log->fatal("get_inventory() $error");
            $c->error($error);
            $c->detach();
            return;
        }
        $c->stash->{'item'} = $item;
    }
    else {
        my $error = qq{inventory item requested (#$inventory_id) not found in database!};
        $c->log->fatal("get_inventory() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    return;
}

sub edit: Chained('get_inventory') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'action_heading'} = 'Edit Inventory Item';

    $c->forward('details');

    return;
}

sub _inventory_form :Private {
    my ($self, $c) = @_;

    my $tank_id = $c->stash->{'tank'}{'tank_id'};

    my $elements = [
        {
            name  => 'inventory_type',
            type  => 'Select',
            empty_first       => 1,
            empty_first_label => '-Inventory Type-',
            options => [
                [ 'consumable'   => 'Consumable'   ],
                [ 'equipment'    => 'Equipment'    ],
                [ 'fish'         => 'Fish'         ],
                [ 'invertebrate' => 'Invertebrate' ],
                [ 'coral'        => 'Coral'        ],
            ],
            constraints => [ 'Required' ],
        },
        {
            name        => 'description',
            type        => 'Text',
            constraints => [
                'Required',
                'Printable',
            ],
        },
        {
            name  => 'purchase_date',
            type  => 'Text',
            constraints => [
                'Required',
# FIXME: DateTime constraint always fails!!
#                 {
#                     type => 'DateTime',
#                     parser => { 'regex' => qr{(\d{4}\D\d{2}\D\d{2})},
#                                 'params' => [ 'purchase_date' ], },
#                 },
            ],
        },
        {
            name        => 'purchase_price',
            type        => 'Text',
            constraints => [
                'Required',
                'Number',
            ],
        },
    ];

    return { elements => $elements };
}


sub details: Chained('get_inventory') PathPart('details') Args(0) FormMethod('_inventory_form') {
    my ( $self, $c ) = @_;

    ## FIXME: make sure we have been called via add() or edit();
    ##        if we haven't, then 404 !!
    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $params = $form->params();

        delete $params->{'submit'};

        try {
            my $inventory;

            my $tank_id = $c->stash->{'tank'}{'tank_id'};

            if ( my $inventory_id = $c->stash->{'water_inventory'}{'inventory_id'} ) {
                $inventory = $c->model('Inventory')->update($inventory_id, $params);
            }
            else {
                $params->{'tank_id'} = $tank_id;
                $params->{'user_id'} = $c->user->user_id();

                $inventory = $c->model('Inventory')->add($params);
            }

           $c->stash->{'message'} = qq{Saved inventory item (no. $inventory->{'inventory_id'}).};

            my $path = qq{/tank/$tank_id/inventory/list};

            $c->response->redirect($c->uri_for($path));
            $c->detach();
            return;
        }
        catch {
            my $err = qq{Error saving inventory results: $_};
            $c->stash->{'error'} = $err;
        };
    }

    ## FIXME: make sure this doesn't clobber newly-entered values
    ##        if/when form redisplay
#     if ( not $form->submitted() and my $inventory = $c->stash->{'water_inventory'} ) {
#         $form->default_values($inventory);
#     }
    $form->default_values($c->stash->{'item'});

    $c->stash->{'col_width'} = 4;
    
    $c->stash->{'template'}  = 'tank/inventory/details.tt2';
    
    return;
}

=encoding utf8

=head1 AUTHOR



=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
