package TankTracker::Common::Tank;

use strict;
use warnings;

use base qw(Exporter);

use Dancer::Plugin::DBIC 'schema';

use List::MoreUtils qw(all none);
use Scalar::Util    qw(looks_like_number);

use TankTracker::Common::Diary qw(save_diary);
use TankTracker::Common::Utils qw(set_message
                                  set_error
                                  db_datetime
                                  TIMEFMT);

our @EXPORT_OK = qw(add_tank
                    get_tank
                    save_tank
                    tank_list
                    valid_tank);

sub get_tank
{
    my $tank_id = shift;

    return $tank_id
           ? schema->resultset('Tank')->find($tank_id)
           : undef;
}

sub add_tank
{
    my $args = shift;

    my $tank = schema->resultset('Tank')
                     ->create($args);

    my $ret;

    eval { $tank->update()->discard_changes(); };

    if ( $@ ) {
        set_error("Error saving new tank: $@");
    }
    else {
        $ret = { 'ok'         => "Saved new tank ok.",
                 'tank_id'    => $tank->tank_id(),
                 'updated_on' => $tank->updated_on()->strftime(TIMEFMT) };

        # Also create a new Diary entry:
        my $diary_args = { 'tank_id'    => $tank->tank_id(),
                           'user_id'    => $args->{user_id},
                           'action'     => 'add',
                           'diary_note' => 'Created new tank.',
                         };

        # don't care if diary entry fails...
        save_diary($diary_args);
    }
    return $ret;
}

sub save_tank
{
    my $args = shift or return undef;

    my $tank = get_tank($args->{'tank_id'});

    if ( ! $tank ) {
        set_error("Tank #$args->{'tank_id'} not found in database!");
        return 0;
    }

    my $upd_type;

    ## notes are always updated separately to other tank details:
    if ( ! $args->{notesOnly} ) {
        $tank->tank_name($args->{'tank_name'});
        $tank->water_id($args->{'water_id'});
        $tank->capacity($args->{'capacity'});
        $tank->capacity_id($args->{'capacity_id'});
        $tank->length($args->{'length'});
        $tank->width($args->{'width'});
        $tank->depth($args->{'depth'});
        $tank->dimension_id($args->{'dimension_id'});
        $upd_type = 'details';
    }
    else {
        $tank->notes($args->{notes});
        $upd_type = 'notes';
    }

    $tank->updated_on(db_datetime());

    eval { $tank->update(); };

    if ( $@ ) {
	print STDERR "save_tank() error: $@\n";
        set_error("Error updating tank $upd_type: $@");
        return 0;
    }

    # make a diary entry
    my $diary_args = { 'tank_id'    => $tank->tank_id(),
                       'user_id'    => $args->{user_id},
                       'action'     => 'add',
                       'diary_note' => "Updated tank $upd_type." };

    # don't care if diary entry fails...
    save_diary($diary_args);

    return $tank->updated_on()->strftime(TIMEFMT);
}

sub tank_list
{
    my $tank_id   = shift;
    my @tanks     = ({ 'tank_id'   => 0,
                       'tank_name' => '-- Select Tank --' });

    my $resultSet = schema->resultset('Tank')
                          ->search(undef,
                                   { 'order_by' => 'tank_id ASC' });

    while ( my $t = $resultSet->next() ) {
            push @tanks, { 'tank_id'    => $t->tank_id(),
                           'tank_name'  => $t->tank_name(),
                           'water_type' => $t->water->water_type(),
                           'selected'   => ($tank_id and $tank_id == $t->tank_id())
                                           ? 'SELECTED'
                                           : undef,
                         };
    }
    return \@tanks;
}

sub valid_tank
{
    my $args = shift;

    ## skip validation when we're only saving the tank notes.
    return 1 if $args->{notesOnly};

    if ( ! $args->{tank_name} ) {
        set_error("Cannot update: missing tank name");
        return 0;
    }

    if ( ! $args->{water_id} ) {
        set_error("Cannot update: missing water type.");
        return 0;
    }

    if ( $args->{capacity} ) {
        if ( ! $args->{capacity_id} ) {
            set_error("Cannot update: missing capacity unit.");
            return 0;
        }
        if ( ! looks_like_number($args->{capacity}) ) {
            set_error("Cannot update: 'capacity' must be numeric.");
            return 0;
        }
    }
    else {
        $args->{capacity_id} ||= 1;   ## default
    }

    my @dims = ( $args->{length}, $args->{width}, $args->{depth} );

    unless ( ( all  { $_ } @dims ) or
             ( none { $_ } @dims ) ) {
        set_error("Cannot update: either all tank dimensions must be defined, or none of them.");
        return 0;
    }

    if ( all  { $_ } @dims ) {
        for my $dim ( qw(length width depth) ) {
            if ( ! looks_like_number($args->{$dim}) ) {
                set_error("Cannot update: '$dim' must be numeric.");
                return 0;
            }
        }
        if ( ! $args->{dimension_id} ) {
            set_error("Cannot update: missing dimension unit.");
            return 0;
        }
    }
    else {
        $args->{dimension_id} ||= 1;   ## default
    }

    1;  ## basic checks pass, tank data s/be valid
}

1;
