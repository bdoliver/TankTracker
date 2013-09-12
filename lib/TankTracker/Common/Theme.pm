package TankTracker::Common::Theme;

use strict;
use warnings;

use base qw(Exporter);

use Dancer::Plugin::DBIC 'schema';

use constant DEFAULT_THEME => 'flick';

our @EXPORT_OK = qw(theme_list DEFAULT_THEME);

sub theme_list {
    my $curr_theme = shift || DEFAULT_THEME;
    my $theme_dir  = Dancer::Config::setting('public').'/css/themes';

    -d $theme_dir or return;

    my @themes;

    for my $d ( sort <$theme_dir/*> ) {
        -d $d or next;  ## only interested in theme dir names

        my ( $theme ) = ( $d =~ m|/([^/]+)$| ) or next;

        my $name  = join(' ', map { ucfirst } split('-', $theme) );

        push @themes, { theme    => $theme,
                        name     => $name,
                        selected => ( $curr_theme and $curr_theme eq $theme )
                                    ? 'SELECTED'
                                    : undef };
    }

    return \@themes;
}

1;
