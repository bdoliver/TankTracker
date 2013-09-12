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
                                  paginate);

use TankTracker::Common::Inventory qw(inventory
                                      save_inventory
                                      inventory_types);

prefix '/inventory';

get '/' => sub {
    my %params = params;

    return paginate({name => 'inventory',
                     recs => inventory(\%params),
                     page => $params{page},
                     rows => $params{rows}});
};

post '/' => sub {
    my %params = params;

    ## jqGrid gives 'oper', but I prefer 'action':
    $params{action} = delete $params{oper};

    ## can't find an easy way to have both type_id & type present in the
    ## jqGrid to display 'type' inline in the row, but edit type_id when
    ##  adding a new record.  So we'll always use 'type' which will contain
    ## the type_id when editing...
    if ( $params{type} and ! defined $params{type_id} ) {
        $params{type_id} = delete $params{type};
    }

    return save_inventory(\%params);
};

get '/types' => sub {
    return template 'select.tt',
                    { rows   => inventory_types(params->{class_id}) },
                    { layout => undef };

#    return '<select>'
#           .join('',map{qq{<option value="$_->{id}">$_->{name}</option>}}
#                        @{inventory_types(params->{class_id})} )
#           .'</select>';
};

1;
