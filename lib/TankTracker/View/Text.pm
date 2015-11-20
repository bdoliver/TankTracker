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

__PACKAGE__->config( {
        CATALYST_VAR       => 'Catalyst',
        TRIM               => 1,
        PRE_CHOMP          => 1,
        POST_CHOMP         => 0,
        TEMPLATE_EXTENSION => '.tt',
        INCLUDE_PATH => [
#             __PACKAGE__->path_to('root', 'lib'),
#             __PACKAGE__->path_to('root', 'src'),
             '../root/lib', '../root/src',
        ],

#        PRE_PROCESS        => 'lib/main.tt2',
        PRE_PROCESS        => undef,

        # see app config files
        # STAT_TTL         => 1,        # 1 second for development
        # STAT_TTL         => 60*60*24, # 1 day for WEBSERVER

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
    }
);

# lets be explicit about our INCLUDE_PATH
#sub new {
#    my ( $class, $c, $arguments ) = @_;
#
#    my $prefix = $c->config->{home};
#
#    push @{ $class->config->{INCLUDE_PATH} }, (
#        dir($prefix, 'root')->stringify(),
#    );
#
#    return $class->next::method($c,$arguments);
#}
1;

