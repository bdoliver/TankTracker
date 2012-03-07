package TankTracker::Common::Diary;

use strict;
use warnings;

use base qw(Exporter);

use Dancer::Plugin::DBIC 'schema';

use TankTracker::Common::Utils qw(pg_datetime);

our @EXPORT_OK = qw(save_diary);

## Save a new, or edited diary entry:
sub save_diary {
	my $args = shift;

	my $tank_id  = $args->{tank_id};
	my $action   = $args->{action};
	my $diary_id = $args->{diary_id};
	my $note     = $args->{diary_note};
	my $date     = pg_datetime();

	my $diary;

	eval {
		if  ( $action eq 'add' ) {
			$diary = schema->resultset('TankDiary')->create({tank_id    => $tank_id,
									 diary_date => $date,
									 diary_note => $note,
									 updated_on => $date});
			$diary or die "Failed to create new diary object!";
		}
		else {
			$diary_id or die "Cannot save diary entry: missing parameter 'diary_id'";

			$diary = schema->resultset('TankDiary')->find($diary_id);

			$diary or die "Failed to load diary record #$diary_id from database";
			# make sure the diary note we fetched actually belongs to the
			# tank we expected:
			( $diary->tank_id() == $tank_id ) or
				die "Diary note #$diary_id does not belong to the selected tank!";

			$diary->diary_note($note);
			$diary->updated_on($date);
		}

		$diary->update();
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

1;
