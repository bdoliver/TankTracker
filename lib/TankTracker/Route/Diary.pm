package TankTracker::Route::Diary;

use strict;
use warnings;

use Dancer ':syntax';

use TankTracker::Common::Diary qw(diary_pages
                                  save_diary
                                  test_note);

use TankTracker::Common::Utils qw(set_message
				  get_message
				  set_error
				  get_error
				  paginate);

prefix '/diary';

get '/' => sub {
    my %params = params;

    return paginate({name => 'diary',
                     recs => diary_pages(\%params),
                     page => $params{page},
                     rows => $params{rows}});
};

## Save a diary page
post '/' => sub {
    my %p = params;

    my $op = $p{oper} or
                die "POST page() failed - no 'oper' param!\n";

    ## jqGrid gives 'oper', but I prefer 'action':
    $p{action} = delete $p{oper};

    save_diary(\%p);
};

## Diary note attached to a specific water test:
get '/test_note' => sub {
    my $test_id = params->{test_id};

    my $ret;

    if ( $test_id ) {
       my $page = test_note({test_id => $test_id});

        if ( $page ) {
             $page->{diary_note} =~ s|\\n|\n|g if $page->{diary_note};
             $ret = { page => [ $page ] };
        }
        else {
             # this ensures that the jqGrid sub-grid sees that there
             # is no note without treating it as an error condition:
             $ret = { page => [ ] };
        }
    }
    else {
        print STDERR "/test_note missing param 'test_id'\n";
    }

    return $ret;
};

1;
