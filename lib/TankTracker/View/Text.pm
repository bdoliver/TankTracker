package TankTracker::View::Text;
use parent 'Catalyst::View::TT';

use strict;
use warnings;

#
# Simply sets up some sane defaults for View::TT
#

use Template::Constants qw(:chomp);
use MRO::Compat;
use Path::Class qw(dir);

#--------------------------------------------------------------------------
#  Constant      Value   Tag Modifier
#  ----------------------------------
#  CHOMP_NONE      0          +       remove no WS
#  CHOMP_ONE       1          -       remove all WS and up to 1 newline
#  CHOMP_COLLAPSE  2          =       collapse all WS into a single space
#  CHOMP_GREEDY    3          ~       remove all WS including any newlines
#--------------------------------------------------------------------------

__PACKAGE__->config({
    CATALYST_VAR => 'Catalyst',
    TRIM               => 1,
    PRE_CHOMP          => 1,
    POST_CHOMP         => 0,

    render_die         => 1,

    # ensure these are never on
    ABSOLUTE           => 0,
    RELATIVE           => 0,
    RECURSION          => 0,
    TOLERANT           => 0,
    EVAL_PERL          => 0,
    INTERPOLATE        => 0,
    ANYCASE            => 0,
    TIMER              => 0,
});

# Set template include paths:
sub new {
    my ( $class, $c, $arguments ) = @_;

    my $prefix = $c->config->{home};

    for my $dir ( qw( lib src ) ) {
        push @{ $class->config->{INCLUDE_PATH} }, (
            dir($prefix, "root/$dir")->stringify(),
        );
    }
    return $class->next::method($c,$arguments);
}
1;
