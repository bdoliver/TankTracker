package TankTracker::View::CSV;

use base qw ( Catalyst::View::CSV );
use strict;
use warnings;

__PACKAGE__->config ( sep_char => "," );

=head1 NAME

TankTracker::View::CSV - CSV view for TankTracker

=head1 DESCRIPTION

CSV view for TankTracker

=head1 SEE ALSO

L<TankTracker>, L<Catalyst::View::CSV>, L<Text::CSV>

=head1 AUTHOR

Brendon Oliver

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;
