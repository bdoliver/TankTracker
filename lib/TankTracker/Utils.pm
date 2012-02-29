package TankTracker::Utils;

use strict;

use base qw( Exporter );

use constant PAGE_CHUNK => 3;

my ( $Message, $Error );

use constant TIMEFMT => '%Y-%m-%d %T (UTC %z)';

our @EXPORT_OK = qw(set_message
		    get_message
		    set_error
		    get_error
		    paginate
		    TIMEFMT);

sub set_message {
	my $msg = shift;

	$Message = $msg;
}
 
sub get_message {
	my $msg  = $Message;
	$Message = "";

	return $msg;
}

sub set_error {
	my $err = shift;

	$Error = $err;
}
 
sub get_error {
	my $err  = $Error;
	$Error = "";

	return $err;
}

### Pagination links for diary notes
sub paginate
{
	my ( $self, $args ) = @_;

	my $total_recs  = $args->{total_recs} || 0;
	my $rec_pp      = $args->{rec_pp};
	my $currentPage = $args->{curr_pg};

	my ( $next, $prev, $num_pages );

	## How many pages of records are there to show?
	my $totalPages = $total_recs / $rec_pp;

	# Round up to next whole number of pages:
	$totalPages = int(++$totalPages) if ( $totalPages > int($totalPages) );

	# Nothing to do if we have a page or less of records to show:
	if (! $total_recs          or
	      $total_recs < $rec_pp  or
	      $totalPages <= 1 ) {
		return {};
	}

	my %pp_params = ( curr_pg    => $currentPage,
			  page_chunk => PAGE_CHUNK );
	my @pp_params = ();

	my $noPages   = PAGE_CHUNK;

	my $relPageDiff = $currentPage % ($noPages + 1);

	my $firstPage = $currentPage - $relPageDiff;
	my $lastPage  = $currentPage + ($noPages - $relPageDiff);

	if ( $lastPage >= $totalPages ) {
		$lastPage = $totalPages;
	}

	if ( $firstPage <= 0 ) {
		$firstPage = 1;
	}

	my $displayNext = 1;
	my $displayPrev = 1;

	if ( $firstPage <= 1 ) {
		$displayPrev = 0;
	}

	if ( ($currentPage + $noPages) > $totalPages ) {
		$displayNext = 0;
	}

	if ( $totalPages > 1 ) {
		if ( (! $displayPrev and $currentPage > 1) or $displayPrev ) {
			$pp_params{first_page}++;
		}

		if ( $displayPrev ) {
			$pp_params{prev_page} = $currentPage - $noPages;
		}
                
		for ( $firstPage .. $lastPage ) {
			push @pp_params, { page      => $_,
					   curr_page => ( $_ == $currentPage ) };
		}
		$pp_params{pages} = \@pp_params;

		if ( $displayNext ) {
			$pp_params{next_page} =  $currentPage + $noPages;
		}

		if ( (! $displayNext and $currentPage < $totalPages) or $displayNext ) {
			$pp_params{last_page} = $totalPages;
		}
	}

	return \%pp_params;
}

1;
