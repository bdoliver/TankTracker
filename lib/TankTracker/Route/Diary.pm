package TankTracker::Route::Diary;

use strict;

use Dancer               ':syntax';
use Dancer::Plugin::DBIC 'schema';

use TankTracker::Common::Diary qw(save_diary);

use TankTracker::Common::Utils qw(set_message
				  get_message
				  set_error
				  get_error
				  paginate);

prefix '/diary';

get '/' => sub {
	my $tank_id = params->{'tank_id'};

	my $tank    = schema->resultset('Tank')->find($tank_id);

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
	return save_diary($args);
};

get '/pages' => sub {
	my $tank_id = params->{tank_id};
	my $date    = params->{diaryDate};
	my $rec_pp  = params->{numDiaryPP} || 0;
	my $curr_pg = params->{curr_pg}    || 1;

	my $query   = { '-and' => [ tank_id => $tank_id ] };

	push @{ $query->{'-and'} }, [ diary_date => { '>=', $date } ] if $date;

	my $pages = schema->resultset('TankDiary')->search($query,
							   { 'order_by' => 'diary_id DESC' });

	my ( @pages, $item, $i, $c );

	my $total_pg = $pages->count();

	my $start = ( $rec_pp * $curr_pg ) - $rec_pp + 1;

	while ( my $p = $pages->next() ) {

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

	my $tt_args = paginate({ total_recs => $total_pg,
				 curr_pg    => $curr_pg,
				 rec_pp     => $rec_pp });

	$tt_args->{diaryPages} = \@pages;
	$tt_args->{curr_pg}    = $curr_pg || 1;

	template 'diaryPages.tt', $tt_args, { layout => undef };
};

1;
