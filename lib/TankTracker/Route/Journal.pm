package TankTracker::Route::Journal;

use strict;
use warnings;

use Dancer               ':syntax';
use Dancer::Plugin::DBIC 'schema';

use TankTracker::Common::Utils qw(set_message
                                  get_message
                                  set_error
                                  get_error
                                  TIMEFMT);
use TankTracker::Common::Tank  qw(tank_list
                                  valid_tank);
use TankTracker::Common::Capacity  qw(capacity_list);
use TankTracker::Common::Dimension qw(dimension_list);
use TankTracker::Common::WaterType qw(watertype_list);

prefix undef;

sub _journal_args {
    my $tank_id = shift;

    return { 'err'       => get_error(),
             'msg'       => get_message(),
             'tanks'     => tank_list($tank_id),
             'types'     => watertype_list(),
             'capacity'  => capacity_list(),
             'dimension' => dimension_list(),
    };
}

get '/journal' => sub {
    template 'journal.tt', _journal_args();
};

post '/journal' => sub {
    my $tank_id = params->{'tank_id'};

    my $tt_args = _journal_args($tank_id);

    if ( $tank_id ) {
        my $tank = schema->resultset('Tank')->find($tank_id);

        if ( $tank ) {
            $tt_args->{page_title}   = 'Journal';
            $tt_args->{tank_id}      = $tank_id;
            $tt_args->{tank_name}    = $tank->tank_name();
            $tt_args->{is_saltwater} = $tank->is_saltwater() || 0;
        }
    }

    template 'journal.tt', $tt_args;
};

1;
