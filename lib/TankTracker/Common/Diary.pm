package TankTracker::Common::Diary;

use strict;
use warnings;

use base qw(Exporter);

use Dancer::Plugin::DBIC 'schema';

use TankTracker::Common::Utils qw(TIMEFMT db_datetime build_gridSearch);

our @EXPORT_OK = qw(save_diary diary_pages test_note);


## Save a new, or edited diary entry:
sub save_diary {
    my $args = shift;

    my $tank_id  = $args->{tank_id};
    my $user_id  = $args->{user_id};
    my $note     = $args->{diary_note};

    # if a test_id iss present in the args passed, make sure
    # it looks like a numeric test_id
    # (autovivification can be a pita! /sigh)
    if ( exists $args->{test_id} ) {
             $args->{test_id} =~ m|^\d+$| or
                    die "**** INVALID TEST ID!!!! ($args->{test_id}) *****\n";
    }

    my $test_id  = $args->{test_id};
    my $date     = db_datetime();

    my $action   = delete $args->{action};
    my $diary_id = delete $args->{diary_id} || delete $args->{id};

    my $diary;

    eval {
        if  ( $action eq 'add' ) {

            $diary = schema->resultset('TankDiary')
                           ->create({tank_id    => $tank_id,
                                     user_id    => $user_id,
                                     diary_date => $date,
                                     diary_note => $note,
                                     test_id    => $test_id,
                                     updated_on => $date});
            $diary or
                die "Failed to create new diary object!";
        }
        else {
            $diary_id or
                die "Cannot save diary entry: missing parameter 'diary_id'";

            $diary = schema->resultset('TankDiary')
                           ->find($diary_id);

            $diary or
                die "Failed to load diary record #$diary_id from database";

            $diary->diary_note($note);
            $diary->updated_on($date);
        }

        $diary->update();  ## save (new or edited)
    };

    my $ret = {};

    if ( $@ ) {
        print STDERR "save_diary() error: $@\n";

        $ret->{err} = "Error saving diary note: $@";
    }
    else {
        $ret->{ok}  = 1;
    }

    return $ret;
}

sub test_note
{
    my $args = shift or return undef;

    my $ret;

    if ( $args->{test_id} ) {
        my $diary = schema->resultset('TankDiary')->find({test_id => $args->{test_id}});

        if ( $diary ) {
            $ret = { diary_id   => $diary->diary_id(),
                     user_id    => $diary->user_id(),
                     diary_note => $diary->diary_note(),
                     diary_date => $diary->diary_date()->strftime(TIMEFMT),
                     updated_on => $diary->updated_on()->strftime(TIMEFMT),
                   };
        }
    }

    return $ret;
}

## return the list of diary pages for a tank:
sub diary_pages
{
    my $args = shift or return undef;

    my $tank_id = $args->{tank_id};
    my $date    = $args->{date};

    my $query   = build_gridSearch($args);

    if ( ! $query->{'-and'} ) {
        $query->{'-and'} = [ 'me.tank_id' => $tank_id ];
    }
    else {
        push @{ $query->{'-and'} }, [ 'me.tank_id' => $tank_id ];
    }

    push @{ $query->{'-and'} }, [ diary_date => { '>=', $date } ] if $date;

    my $sort_col = $args->{sidx} || 'me.diary_date';
    my $sort_dir = $args->{sord} || 'desc';

    my @rows;

    my $rs = schema->resultset('TankDiary')
                   ->search($query,
                            { 'order_by' => "$sort_col $sort_dir" });

    while ( my $page = $rs->next() ) {
        push @rows, { diary_id   => $page->diary_id(),
                      tank_id    => $page->tank_id(),
                      user_id    => $page->user_id(),
                      diary_date => $page->diary_date->ymd(),
                      updated_on => $page->updated_on->ymd(),
                      diary_note => $page->diary_note(),
                      test_id    => $page->test_id()
                    };
    }

    return \@rows;
}

1;
