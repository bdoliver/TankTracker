package TankTracker::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
    PRE_CHOMP  => 1,

);

=head1 NAME

TankTracker::View::HTML - TT View for TankTracker

=head1 DESCRIPTION

TT View for TankTracker.

=head1 SEE ALSO

L<TankTracker>

=head1 AUTHOR

Brendon Oliver <brendon.oliver@gmail.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

