package TankTracker::Route::Inventory;

use strict;
use warnings;

use Dancer               ':syntax';
use Dancer::Plugin::DBIC 'schema';

use DateTime;
use DateTime::Format::Pg;

use TankTracker::Common::Utils qw(set_message
				  get_message
				  set_error
				  get_error
				  TIMEFMT);

prefix '/inventory';

get '/equipment' => sub {

};

get '/livestock' => sub {

};

get '/consumables' => sub {

};

1;
