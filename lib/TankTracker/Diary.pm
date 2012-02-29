package TankTracker::Diary;

use strict;

use Dancer ':syntax';

use DateTime;
use DateTime::Format::Pg;

use TankTracker::Model::Tank;
use TankTracker::Model::TankDiary;
use TankTracker::Model::TankDiary::Manager;

use TankTracker::Utils qw(set_message
		          get_message
		          set_error
		          get_error
		          TIMEFMT);

prefix '/diary';

## Save a new, or edited diary entry:
sub _save_diary {
	my $args = shift;

	my $tank_id  = $args->{tank_id};
	my $action   = $args->{action};
	my $diary_id = $args->{diary_id};
	my $note     = $args->{diary_note};
	my $date     = DateTime::Format::Pg->format_datetime(DateTime->now()->set_time_zone('Australia/Melbourne'));

	my $diary;

	eval {
		if  ( $action eq 'add' ) {
			$diary = TankTracker::Model::TankDiary->new(tank_id    => $tank_id,
								    diary_date => $date,
								    diary_note => $note,
								    updated_on => $date);
			$diary or die "Failed to create new diary object!";
		}
		else {
			$diary_id or die "Cannot save diary entry: missing parameter 'diary_id'";

			$diary = TankTracker::Model::TankDiary->new(diary_id => $diary_id);
			$diary->load();
			$diary or die "Failed to load diary record #$diary_id from database";
			# make sure the diary note we fetched actually belongs to the
			# tank we expected:
			( $diary->tank_id() == $tank_id ) or
				die "Diary note #$diary_id does not belong to the selected tank!";

			$diary->diary_note($note);
			$diary->updated_on($date);
		}

		$diary->save();
	};

	my $ret = {};

	if ( $@ ) {
		$ret->{err} = "Error saving diary note: $@";
	}
	else {
		$ret->{ok} = 1;
	}

	return $ret;
};

get '/' => sub {
	my $tank_id = params->{'tank_id'};

	my $tank    = TankTracker::Model::Tank->new(tank_id => $tank_id);

	$tank->load();

	template 'diary.tt', 
		 { tank_id => $tank_id },
		 { layout  => undef };
};


## Save a new, or edited diary entry:
post '/' => sub {
	my $args = { tank_id  => params->{tank_id}.
		     action   => params->{action}.
		     diary_id => params->{diary_id},
		     note     => params->{diary_note} };

	# returns JSON status:
	return _save_diary($args);
};

get '/pages' => sub {
	my $tank_id = params->{tank_id};
	my $date    = params->{diaryDate};
	my $rec_pp  = params->{numDiaryPP} || 0;
	my $curr_pg = params->{curr_pg}    || 1;

	my $query   = [ tank_id => $tank_id ];

	push @$query, ( diary_date => { ge => $date } ) if $date;

	my %query = ( query   => $query,
		      sort_by => 'diary_id DESC' );

	my $pages = TankTracker::Model::TankDiary::Manager->get_tank_diary(%query);
	my @pages = ();

	my $total_pg = @$pages;

	if ( $pages and @$pages ) {
		my ( $item, $i, $c );

		my $start = ( $rec_pp * $curr_pg ) - $rec_pp + 1;

		for my $p ( @$pages ) {

			# 'item' is just a sequential number so that the
			# diary entries appear ordered in the UI:
			++$item;

			my $id   = $p->diary_id();

			my $note =  $p->diary_note();
			   $note =~ s|<|&lt;|msg;
			   $note =~ s|>|&gt;|msg;
			   $note =~ s|\n|<br />|msg;

			my $upd  =  $p->updated_on();
			   $upd  =~ s|T|<br />|;

			my $page =  { item       => $item,
				      diary_id   => $id,
				      diary_date => $p->diary_date()->ymd(),
				      diary_note => $note,
				      updated_on => $upd,
				      test_id    => $p->test_id() };

			if ( ! $rec_pp ) {
				push @pages, $page;
				next;
			}

			if ( ++$i >= $start and ++$c <= $rec_pp ) {
				push @pages, $page;
				last if $c == $rec_pp;
			}
		}
	}

	my $tt_args =  TankTracker::Utils->paginate({ total_recs => $total_pg,
						      curr_pg    => $curr_pg,
						      rec_pp     => $rec_pp });

	$tt_args->{diaryPages} = \@pages;
	$tt_args->{curr_pg}    = $curr_pg || 1;

	template 'diaryPages.tt', $tt_args, { layout => undef };
};

1;