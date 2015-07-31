package TankTracker::Model::Access;

use strict;

use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'TankUserAccess',
);

sub update {
    my ( $self, $args ) = @_;

    for my $param ( qw( mode id ) ) {
        # id = 0 is invalid, so this works:
        $args->{$param} or die "update() missing mandatory param '$param'";
    }

    my $key = $args->{'mode'}.'_id';
    my $id  = $args->{'id'};

    my ( %access, %admin );
    my @access = @{ $args->{'access'} || [] };
    my @admin  = @{ $args->{'admin'}  || [] };

    @access{@access} = (1) x @access;
    @admin{@admin}   = (1) x @admin;

    try {
        $self->schema->txn_do(
            sub {
                my $col = ( $args->{'mode'} eq 'user' ) ? 'tank_id' : 'user_id';

                my $current_access = $self->search({ $key => $id });

                while ( my $rec = $current_access->next() ) {
                    if ( my $access_id = delete $access{$rec->$col()} ) {
                        # user has access to this record so update their
                        # admin (just do it, saves checking...)
                        $rec->admin($admin{$rec->$col()});
                        $rec->update();
                    }
                    else {
                        # user has no access to this record, so remove it:
                        $rec->delete();
                    }
                }

                # any keys left in %access represent _new_ access records
                # which we must add:
                for my $access_id ( keys %access ) {
                    $self->schema->resultset('TankUserAccess')->create({
                         $key    => $id,
                         $col    => $access_id,
                         'admin' => $admin{$access_id}, # may be undef!
                    });
                }
                return 1; # do_txn() ok
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
