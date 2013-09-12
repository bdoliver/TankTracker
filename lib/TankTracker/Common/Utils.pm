package TankTracker::Common::Utils;

use strict;
use warnings;

use base qw( Exporter );

use Dancer qw(:syntax);

use Carp;
use Data::Page;

use DateTime::Format::Pg;
use DateTime::Format::SQLite;

use List::MoreUtils qw();  ## we want 'any' but it clashes with Exporter!

use constant PAGE_CHUNK   => 3;
use constant START_PAGE   => 1;
use constant REC_PER_PAGE => 10;

use constant TIMEFMT      => '%Y-%m-%d %T (UTC %z)';

our @EXPORT_OK = qw(set_message
                    get_message
                    set_error
                    get_error
                    db_datetime
                    build_gridSearch
                    paginate
                    START_PAGE
                    REC_PER_PAGE
                    TIMEFMT);

our ( $Message, $Error );

sub db_driver {
    my $dsn = config->{plugins}->{DBIC}->{default}->{dsn};

    my ( $driver ) = ( $dsn =~ m|dbi:(\w+):dbname| );

    return $driver;
}

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
    $Error  = $err;
}

sub get_error {
    my $err = $Error;
    $Error  = "";

    return $err;
}

sub db_datetime {
    my $date = shift;

    if ( ! $date ) {
        my $tz = setting('timezone') || 'Australia/Melbourne';

        $date  = DateTime->now()->set_time_zone($tz);
    }

    my $db_driver = db_driver() or
        die "db_datetime() can't determine which DBI driver is in use!\n";

    my $datetimeFormatter;

    if ( $db_driver eq 'Pg' or $db_driver eq 'SQLite' ) {
            $datetimeFormatter = "DateTime::Format::$db_driver";
    }
    else {
        die "db_datetime() only supports Pg & SQLite databases for now...\n";
    }

    return $datetimeFormatter->format_datetime($date);
}

## build a DBIx::Class 'WHERE' clause to search for something
## when called from jqGrid search popup.
## When jqGrid sends a search request, there are 12 different
## match operators, one of which is required:
## eq    equal
## ne    not equal
## bw    begins with
## bn    does not begin with
## ew    ends with
## en    does not end with
## cn    contains
## nc    does not contains
## nu    is null
## nn    is not null
## in    is in
## ni    is not in
sub build_gridSearch {
    my $params = shift;

    my $search = $params->{_search};

    # bail early if search not required:
    return undef if ( $search and $search eq 'false' );

    my $col = $params->{searchField};
    my $op  = $params->{searchOper};
    my $val = $params->{searchString};

    # need at least the column & match operator
    # (value can be null / empty string / zero... whatever)
    ( $col and $op ) or return undef;

    my $s;

    if ( $op eq 'eq' ) {
        $s = { $col => $val };
    }
    elsif ( $op eq 'ne' ) {
        $s = { $col => { '!=' => $val } };
    }
    elsif ( List::MoreUtils::any { $op eq $_ } (qw(bw nb cn nc ew en)) ) {
        if ( List::MoreUtils::any { $op eq $_ } (qw(bw nb cn nc)) ) {
            $val .= '%';
        }
        if ( List::MoreUtils::any { $op eq $_ } (qw(ew en cn nc)) ) {
            $val = "\%$val";
        }
        if (List::MoreUtils::any { $op eq $_ } (qw(bw cn ew)) ) {
            $s = { $col => { 'like' => $val } };
        }
        else {
             $s = { '-not' => [ $col => { 'like' => $val } ] };
        }
    }
    elsif ( $op eq 'nu' ) {
        $s = { $col => undef };
    }
    elsif ( $op eq 'nn' ) {
        $s = { $col => { '!=' => undef } };
    }
    elsif ( $op eq 'in' or $op eq 'ni' ) {
        $val = [ map { s/^\s*//; s/\s*$//; $_ } split(',', $val) ];
        $op = 'not_in' if $op eq 'ni';
        $s = { $col => { "-$op" => $val } };
    }
    else {
        croak "Unrecognised search operator '$op'!\n";
    }

    return $s;
}

# sub paginate {
#     my $args = shift;
# 
#     my $name = $args->{name};
#     my $recs = $args->{recs} || [];
#     my $page = $args->{page} || START_PAGE;
#     my $rows = $args->{rows} || REC_PER_PAGE;
# 
#     my ($start_row, $end_row);
# 
#     my $total_records = scalar @$recs;
#     my $pagination    = {};
# 
#     if ( $total_records ) {
#         my $total_pages  = int($total_records / $rows);
#            $total_pages += ($total_records % $rows) ? 1 : 0;
# 
#         $start_row = ( $page - 1 ) * $rows;
#         $end_row   = ( $start_row + $rows <= $total_records )
#                         ? $start_row + $rows
#                         : $total_records;
#         ++$start_row;
# 
#         $pagination->{total_records} = $total_records;
#         $pagination->{total_pages}   = $total_pages;
#         $pagination->{current_page}  = $page;
#     }
# 
#     my ( $idx, @rows );
# 
#     for my $r ( @$recs ) {
#         if ( $start_row and $end_row ) {
#             if ( ++$idx < $start_row ) {
#                 next;
#             } else {
#                 last if $idx > $end_row;
#             }
#         }
#         push @rows, $r;
#     }
# 
#     $pagination->{$name} = \@rows;
# 
#     return $pagination;
# }

sub paginate {
    my $args = shift;

    my $name = $args->{name};
    my $recs = $args->{recs} || [];
    my $page = $args->{page} || START_PAGE;
    my $rows = $args->{rows} || REC_PER_PAGE;

    my $pager = Data::Page->new();
    
    $pager->total_entries(scalar @$recs);
    $pager->entries_per_page($rows);
    
    my $pagination = { total_records => $pager->total_entries(),
                       total_pages   => $pager->last_page(),
                       current_page  => $page,
                       $name         => $pager->splice($recs),
                     };

#     my ($start_row, $end_row);
# 
#     my $total_records = scalar @$recs;
#     my $pagination    = {};
# 
#     if ( $total_records ) {
#         my $total_pages  = int($total_records / $rows);
#            $total_pages += ($total_records % $rows) ? 1 : 0;
# 
#         $start_row = ( $page - 1 ) * $rows;
#         $end_row   = ( $start_row + $rows <= $total_records )
#                         ? $start_row + $rows
#                         : $total_records;
#         ++$start_row;
# 
#         $pagination->{total_records} = $total_records;
#         $pagination->{total_pages}   = $total_pages;
#         $pagination->{current_page}  = $page;
#     }
# 
#     my ( $idx, @rows );
# 
#     for my $r ( @$recs ) {
#         if ( $start_row and $end_row ) {
#             if ( ++$idx < $start_row ) {
#                 next;
#             } else {
#                 last if $idx > $end_row;
#             }
#         }
#         push @rows, $r;
#     }
# 
#     $pagination->{$name} = \@rows;
# 
#     return $pagination;
}

1;
