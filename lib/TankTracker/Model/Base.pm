package TankTracker::Model::Base;

use strict;
use base 'Catalyst::Model';
use Carp;
use Log::Any qw($log);
use Moose;
use Try::Tiny;
use Readonly;

use namespace::autoclean;

has 'schema' => (
  is  => 'rw',
  isa => 'DBIx::Class::Schema',
);

has 'no_deflate' => (
  is  => 'ro',
  default => 1,
);

sub initialise_after_setup {
    my ( $self, $app ) = @_;

    return $self->schema($app->model('TankTracker')->schema());
}

sub rs_name {
    my $self = shift;

    croak "Class ".ref($self)." does not provide a rs_name() method!";
}

sub resultset {
    my  ( $self, $rs_list ) = @_;

    my $rs_name = ( $rs_list and $self->can($rs_list) )
                    ? $self->rs_list()
                    : $self->rs_name();

    my $resultset = $self->schema->resultset($rs_name);

    return $resultset;
}

sub columns {
    my $self = shift;

    return $self->schema->source($self->rs_name())->columns();
}

sub get {
    my ( $self, $id, $args ) = @_;

    my $no_deflate;

    if ( $args and ref($args) eq 'HASH' ) {
        $no_deflate = delete $args->{'no_deflate'};
    }

    my $object = $self->resultset->find($id, $args || {});

    return $no_deflate ? $object : $self->deflate($object);
}

sub list {
    my ( $self, @args ) = @_;

    ## @args is generally: ( { ...search... }, { ...sort/paginate...}
    ## The sort/paginate hashref may contain an optional 'no_deflate'
    ## key.  When present (as a true value), we do not call deflate()
    ## on the resultset, instead returning it as-is:
    my $no_deflate;

    if ( @args and $args[1] ) {
        $no_deflate = delete $args[1]{'no_deflate'};
    }

    my $result = $self->resultset('rs_list')->search(@args);

    return $no_deflate ? $result : $self->deflate($result);
}

sub deflate {
    my ( $self, $result ) = @_;

    # don't attempt to deflate nothing...
    $result or return;

    ## If the result is a ResultSet object, then use HashRefInflator:
    if ( ref($result) eq 'DBIx::Class::ResultSet' ) {
        $result->result_class('DBIx::Class::ResultClass::HashRefInflator');

        my @rows  = $result->all();
        my $pager = $result->is_paged() ? $result->pager() : undef;

        return $pager ? [ \@rows, $pager ] : \@rows;
    }

    ## guess it's a plain "object", so deflate it manually:
    return { $result->get_columns() };
}

sub add_diary {
    my ( $self, $params ) = @_;

    $params or return;

    for my $attr ( qw( tank_id user_id diary_note ) ) {
        $params->{$attr} or
            croak "add_diary() missing required param: '$attr'";
    }

    my $note;

    # adding a diary note is non-fatal...
    try {
        $note = $self->schema->resultset('Diary')->create($params);
    }
    catch {
        $log->warn("*** add_diary() failed: $_");
    };

    return $self->deflate($note);
}

sub search {
    my $self = shift;

    return $self->resultset->search(@_);
}

sub result_source {
    my $self = shift;

    return $self->resultset->result_source(@_);
}

sub AUTOLOAD {
    my $self = shift;
    my $name = our $AUTOLOAD;

    $name =~ s/.*:://;

    if ( not $self->can($name) and
         $self->resultset->can($name) ) {
        my $me = ref $self;
        $log->warn("**** $me: forwarding unresolved method '$name' to resultset via AUTOLOAD!!");
        no strict 'refs';
        *$AUTOLOAD = sub {
            return $self->resultset->$name(@_);
        };
        goto &$AUTOLOAD;    # Restart the new routine.
    }
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
