# base class for all Model (table) objects
package TankTracker::Model::Object;

use base 'Rose::DB::Object';

use TankTracker::Model::DB;

sub init_db { TankTracker::Model::DB->new_or_cached(); }

sub as_hash {
        my $self = shift;
        my @cols = $self->meta()->column_names();
        my $hash = {};

        for my $c ( @cols ) {
                my $coltype = ref($self->$c);
                my $val;
                                                                                   
                if ( $coltype and $coltype eq 'DateTime' ) {                       
                        $val = $self->$c->strftime('%Y-%m-%dT%H:%M:%S');           
                }                                                                  
                else {                                                             
                        $val = $self->$c;                                          
                }                                                                  
                                                                                   
                $hash->{$c} = $val;                                                
        }                                                                          
                                                                                   
        return $hash;                                                              
}                                                                                  
1;

