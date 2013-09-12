package TankTracker::Route::Tank;

use strict;
use warnings;

use Dancer ':syntax';

use TankTracker::Common::Tank  qw(tank_list
                                  get_tank
                                  add_tank
                                  save_tank
                                  valid_tank);
use TankTracker::Common::Utils qw(get_message
				  get_error
				  TIMEFMT);

prefix '/tank';

get '/' => sub {
    my $tank = get_tank(params->{'tank_id'});

    my $tt_args;

    if ( $tank ) {
        $tt_args = { tank_id      => $tank->tank_id(),
                     is_saltwater => $tank->is_saltwater(),
                     updated_on   => $tank->updated_on()
                                     ? $tank->updated_on()->strftime(TIMEFMT)
                                     : undef,
                     notes        => $tank->notes() };
    }

    template 'tank.tt', $tt_args, { layout => undef };
};

## POST = saving (edited) tank details, notes, etc.:
post '/' => sub {
    my $args = _get_args();

    my $ret;

    if ( valid_tank($args) ) {
        my $upd = save_tank($args);

        if ( $upd ) {
            $ret = { 'ok'         => 1,
                     'tank_id'    => $args->{tank_id},
                     'updated_on' => $upd, };
        }
        else {
            $ret = { 'err' => get_error() };
        }
    }
    else {
        $ret = { 'err' => get_error() };
    }

    ## returning AJAX...
    return $ret;
};

post '/add' => sub {
    my $args = _get_args();

    my $ret;

    if ( valid_tank($args) ) {
        $ret = add_tank($args);

        if ( ! $ret ) {
            $ret = { 'err' => get_error() };
        }
    }
    else {
        $ret = { 'err' => get_error() };
    }

    ## returning AJAX...
    return $ret;
};

get '/list' => sub {
    return tank_list(params->{'tank_id'});
};

sub _get_args
{
    return { tank_id      => params->{'tank_id'},
             tank_name    => params->{'tankName'},
             water_id     => params->{'tankType'},
             user_id      => session->{'user_id'},
             capacity     => params->{'tankCapacity'} || 0,
             capacity_id  => params->{'capacityUnit'},
             length       => params->{'tankLength'}   || 0,
             width        => params->{'tankWidth'}    || 0,
             depth        => params->{'tankDepth'}    || 0,
             dimension_id => params->{'dimensionUnit'},
             notes        => params->{'notes'},
             notesOnly    => params->{'notesOnly'},
           };
}

1;
