package TankTracker::Controller::Tank::Diary;
use Moose;
use namespace::autoclean;

BEGIN { extends q{Catalyst::Controller::HTML::FormFu} }

with q{TankTracker::TraitFor::Controller::Tank};

use DateTime;
use Try::Tiny;

=head1 NAME

TankTracker::Controller::Tank::Diary - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub auto :Private {
    my ($self, $c) = @_;

    return 1;
}

sub _search_diary {
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
            name  => 'diary_note',
            type  => 'Text',
        },
        {
            name  => 'test_id',
            type  => 'Text',
            constraints => [ 'Number' ],
        },
    ];

    return { elements => $elements };
}

sub list: Chained('get_tank') PathPart('diary/list') FormMethod('_search_diary') {
    my ($self, $c, $page, $column, $direction) = @_;

    $page      ||= 1;
    $column    ||= 'diary_date',
    $direction ||= 'desc';

    my $tank_id = $c->stash->{'tank'}{'tank_id'};
    my $search  = {
        tank_id => $tank_id,
    };

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $params = $form->params();
        my @filter = ();

        ## NB: diary_date is a timestamp, so we'll append HH:MM:SS to get
        ##     the required start/end range:
        if ( $params->{'start_date'} ) {
            push @filter,
                [ 'diary_date' => { '>=', $params->{'start_date'}.' 00:00:00' } ];
        };
        if ( $params->{'end_date'} ) {
            push @filter,
                [ 'diary_date' => { '<=', $params->{'end_date'}.' 23:59:59'   } ];
        };
        if ( $params->{'diary_note'} ) {
            push @filter,
                [ 'diary_note' => { 'ilike', sprintf('%%%s%%', $params->{'diary_note'}) } ];
        };
        if ( $params->{'test_id'} ) {
            push @filter,
                [ 'test_id' => $params->{'test_id'} ];
        };

        $search->{'-and'} = \@filter if @filter;
    }

    my ( $diary, $pager ) = @{ $c->model('Diary')->list(
        $search,
        {
            prefetch => 'tracker_user',
            order_by => [
                { "-$direction" => $column    },
                { "-desc"       => 'diary_id' },
            ],
            page     => $page,
            rows     => $c->stash->{'user'}{'preferences'}{'recs_per_page'} || 10,
        },
    ) };

    for my $d ( @{ $diary } ) {
        my $user   = delete $d->{'tracker_user'};
        my $name   = $user->{'first_name'} || '';
           $name  .= $user->{'last_name'} ? " $user->{'last_name'}" : '';
           $name ||= $user->{'username'};

        $d->{'diary_user'} = $name;
    }

    if ( $pager and ref($pager) ) {
        $pager->{'what'}      = 'diary notes';
        $pager->{'path'}      = [ '/tank', $tank_id, 'diary/list', $page ];
        $pager->{'column'}    = $column;
        $pager->{'direction'} = $direction;
    }

    $c->stash->{'diary'}          = $diary;
    $c->stash->{'pager'}          = $pager;
    $c->stash->{'action_heading'} = 'Diary';
    $c->stash->{'add_url'}        = qq{/tank/$tank_id/diary/add};

    if ( my $status = delete $c->flash->{'del_status'} ) {
        $c->stash->{'message'} = $status->{'msg'};
        $c->stash->{'error'}   = $status->{'err'};
    }

    return 1;
}

sub _diary_form : Private {
    my ($self, $c) = @_;

    my $tank_id = $c->stash->{'tank'}{'tank_id'};

    my $elements = [
        {
            name  => 'diary_date',
            type  => 'Text',
            value => $c->stash->{'diary'} || DateTime->now()->ymd(),
            constraints => [
                {
                    type    => 'Required',
                    message => q{You must enter a date for this diary entry.},
                },
            ],
        },
        {
            name  => 'diary_note',
            type  => 'Textarea',
            rows  => 10,
            cols  => 110,
            constraints => [ 'ASCII', 'Required' ],
            filter  => [
                'HTMLScrubber',
                'TrimEdges',
                {
                    type    => 'Regex',
                    match   => qr{\r},
                    replace => '',
                }
            ],
        },
        {
            name  => 'test_id',
            type  => 'Text',
            constraints => [ 'Number' ],
        },
        {
            type => 'Submit',
            name => 'submit',
        },
    ];

    return { 'elements' => $elements };
}

sub add :Chained('get_tank') PathPart('diary/add') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{'action_heading'} = 'Add Diary Note';
    $c->stash->{'add_diary'}      = 1;
    $c->forward('details');

    return;
}

sub get_diary :Chained('get_tank') PathPart('diary') CaptureArgs(1) {
    my ( $self, $c, $diary_id ) = @_;

    if ( ! $diary_id ) {
        ## Should never happen...
        my $error = qq{Missing diary_id!};
        $c->log->fatal("get_diary() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( $diary_id !~ qr{\A \d+ \z}msx ) {
        my $error = qq{Invalid diary_id '$diary_id'};
        $c->log->fatal("get_diary() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( my $diary = $c->model('Diary')->get($diary_id) ) {
        if ( $diary and $diary->{'tank_id'} != $c->stash->{'tank'}{'tank_id'} ) {
            my $error = qq{Diary requested ($diary_id) does not belong to current tank!};
            $c->log->fatal("get_diary() $error");
            $c->error($error);
            $c->detach();
            return;
        }

        $c->stash->{'diary'} = $diary;
    }
    else {
        my $error = qq{Diary requested ($diary_id) not found in database!};
        $c->log->fatal("get_diary() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    return;
}

sub edit :Chained('get_diary') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{'action_heading'} = 'Edit Diary Note';
    $c->stash->{'edit_diary'}      = 1;
    $c->forward('details');

    return;
}

sub details: Chained('get_diary') PathPart('diary/details') Args(0) FormMethod('_diary_form') {
    my ($self, $c) = @_;

    ## FIXME: make sure we have been called via add() or edit();
    ##        if we haven't, then 404 !!
    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $params = $form->params();

        $params->{'user_id'}   = $c->user->user_id();
        $params->{'test_id'} ||= undef;

        delete $params->{'submit'};

        try {
            my $note;

            my $tank_id = $c->stash->{'tank'}{'tank_id'};

            $params->{'tank_id'} = $tank_id;

            if ( my $diary_id = $c->stash->{'diary'}{'diary_id'} ) {
                $note = $c->model('Diary')->update($diary_id, $params);
            }
            else {
                $note = $c->model('Diary')->add_diary($params);
            }

            $c->stash->{'message'} = qq{Saved diary note (no. $note->{'diary_id'}).};

            my $path = qq{/tank/$tank_id/diary/list};

            $c->response->redirect($c->uri_for($path));
            $c->detach();
            return;
        }
        catch {
            my $err = qq{Error saving diary note: $_};
            $c->stash->{'error'} = $err;
        };
    }

    $form->default_values($c->stash->{'diary'});

    $c->stash->{'template'} = 'tank/diary/details.tt';

    return;
}

sub delete :Chained('get_diary') PathPart('delete') Args(0) {
    my ( $self, $c ) = @_;
    
    my $tank_id = $c->stash->{'tank'}{'tank_id'};

    my $status = {};

    try {
        $c->model('Diary')->delete($c->stash->{'diary'}{'diary_id'});
        $status->{'msg'} = q{Deleted diary note ok};
    }
    catch {
        $status->{'err'} = qq{Error deleting diary note: $_};
    };

    my $path = qq{/tank/$tank_id/diary/list};

    $c->flash->{'del_status'} = $status;

    $c->response->redirect($c->uri_for($path));
    $c->detach();

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
