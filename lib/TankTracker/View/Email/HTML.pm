package TankTracker::View::Email::HTML;
use Moose;
use namespace::autoclean;

extends 'TankTracker::View::Email';

__PACKAGE__->config(
    # Where to look in the stash for the email information.
    # 'email' is the default, so you don't have to specify it.
    stash_key => 'email',
    # Define the defaults for the mail
    template_prefix => 'email',
    default => {
        view => 'Text',
        # Defines the default content type (mime type). Mandatory
        content_type => 'text/html',
        # Defines the default charset for every MIME part with the
        # content type text.
        # According to RFC2049 a MIME part without a charset should
        # be treated as US-ASCII by the mail client.
        # If the charset is not set it won't be set for all MIME parts
        # without an overridden one.
        # Default: none
        charset => 'utf-8'
    },

    # Setup how to send the email
    # all those options are passed directly to Email::Sender::Simple
    sender => {
        # if mailer doesn't start with Email::Sender::Simple::Transport::,
        # then this is prepended.
        mailer => 'SMTP',
        # mailer_args is passed directly into Email::Sender::Simple
        mailer_args => {
            #host     => 'smtp.example.com', # defaults to localhost
            host     => 'localhost', # defaults to localhost
            sasl_username => 'sasl_username',
            sasl_password => 'sasl_password',
        }
    }
);

=head1 NAME

TankTracker::View::Email::HTML - HTML Email View for TankTracker

=head1 DESCRIPTION

HTML Email View for TankTracker.

=head1 SEE ALSO

L<TankTracker>

=head1 AUTHOR

Brendon Oliver <brendon.oliver@gmail.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

