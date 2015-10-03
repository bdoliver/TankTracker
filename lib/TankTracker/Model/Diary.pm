package TankTracker::Model::Diary;

use strict;

use Moose;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'Diary',
);

sub update {
    my ( $self, $diary_id, $args ) = @_;

    my $diary = $self->resultset->find($diary_id);

    $diary or die "Diary #$diary_id not found in database\n";

    $diary->update($args);


    return $self->deflate($diary);
}

sub delete {
    my ( $self, $diary_id ) = @_;

    my $diary = $self->resultset->find($diary_id);

    $diary or die "Diary #$diary_id not found in database\n";

    $diary->delete();

    return 1;
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
