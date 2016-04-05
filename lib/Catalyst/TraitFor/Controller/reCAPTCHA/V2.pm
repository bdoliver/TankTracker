package Catalyst::TraitFor::Controller::reCAPTCHA::V2;
{
  $Catalyst::TraitFor::Controller::reCAPTCHA::V2::VERSION = '1.0';
}

use Moose::Role;
use MooseX::MethodAttributes::Role;
use namespace::autoclean;

use Captcha::reCAPTCHA::V2;
use Carp 'croak';

has recaptcha => ( is => 'ro', default => sub { Captcha::reCAPTCHA::V2->new } );

sub captcha_get :Private {
    my ( $self, $c ) = @_;

    my $recaptcha = $self->recaptcha->html(
        $c->config->{recaptcha}{site_key},
        $c->config->{recaptcha}{options},
    );

    $c->stash( recaptcha => $recaptcha );
}

sub captcha_check :Private {
    my ( $self, $c ) = @_;

    my $response  = $c->req->param('g-recaptcha-response');

    unless ( $response ) {
        $c->stash->{recaptcha_error} = 'User appears not to have submitted a recaptcha';
        return;
    }

    my $res = $self->recaptcha->verify(
        $c->config->{recaptcha}{secret},
        $response,
        $c->req->address,
    );

    croak 'Failed to get valid result from reCaptcha'
        unless ref $res eq 'HASH';

    unless ( $res->{success} ) {
        $c->stash( recaptcha_error => $res->{error_codes} || 'Invalid recaptcha' );
    }

    $c->stash( recaptcha_ok => $res->{success} );
    return $res->{success};
}

1;


__END__
=pod

=head1 NAME

Catalyst::TraitFor::Controller::reCAPTCHA::V2 - authenticate people and read books!

=head1 VERSION

version 1.0

=head1 SYNOPSIS

In your controller

    package MyApp::Controller::Comment;
    use Moose;
    use namespace::autoclean;

    BEGIN { extends 'Catalyst::Controller' }
    with 'Catalyst::TraitFor::Controller::reCAPTCHA::V2';

    sub example : Local {
        my ( $self, $c ) = @;

        # validate received form
        if ( $c->forward('captcha_check') ) {
            $c->detach('my_form_is_ok');
        }

        # Set reCAPTCHA html code
        $c->forward('captcha_get');
    }

    1;

=head1 SUMMARY

Catalyst::Controller role around L<Captcha::reCAPTCHA:L:V2>.
Provides a number of C<Private> methods that deal with the recaptcha.

This module is based/copied from L<Catalyst::TraitFor::Controller::reCAPTCHA>,
modified to suit the reCATPCHA v2 api (as provided by
L<Captcha::reCAPTCHA:L:V2>.

=head2 CONFIGURATION

In MyApp.pm (or equivalent in config file):

 __PACKAGE__->config->{recaptcha} = {
    site_key => '6LcsbAAAAAAAAPDSlBaVGXjMo1kJHwUiHzO2TDze',
    secret   => '6LcsbAAAAAAAANQQGqwsnkrTd7QTGRBKQQZwBH-L',
    options  => {
        theme => 'light',
        type  => 'image',
        size  => 'compact',
    },
 };

(the two keys above work for http://localhost unless someone hammers the
reCAPTCHA server with failures, in which case the API keys get a temporary
ban).

=head2 METHODS

=head3 captcha_get : Private

Sets $c->stash->{recaptcha} to be the html form for the
L<http://recaptcha.net/> reCAPTCHA service which can be included in your
HTML form.

=head3 captcha_check : Private

Validates the reCaptcha using L<Captcha::reCAPTCHA::V2>.  sets
$c->stash->{recaptcha_ok} which will be 1 on success. The action also returns
true if there is success. This means you can do:

 if ( $c->forward(captcha_check) ) {
   # do something based on the reCAPTCHA passing
 }

or alternatively:

 $c->forward(captcha_check);
 if ( $c->stash->{recaptcha_ok} ) {
   # do something based on the reCAPTCHA passing
 }

If there's an error, $c->stash->{recaptcha_error} is
set with the error string provided by L<Captcha::reCAPTCHA::V2>.

=head1 SEE ALSO

=over 4

=item *

L<Captcha::reCAPTCHA::V2>

=item *

L<Catalyst::Controller> 

=item *

L<Catalyst>

=back

=head1 ACKNOWLEDGEMENTS

This module is almost copied from Kieren Diment L<Catalyst::Controller::reCAPTCHA>.

=head1 AUTHOR

Brendon Oliver <brendon.oliver@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Brendon Oliver.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

