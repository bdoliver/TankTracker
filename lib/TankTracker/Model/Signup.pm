package TankTracker::Model::Signup;

use strict;

use JSON::WebToken;
use Moose;
use Try::Tiny;
use namespace::autoclean;

extends 'TankTracker::Model::Base';

has 'rs_name' => (
    is      => 'ro',
    default => 'Signup',
);

## Need a random string of chars as secret for JSON::WebToken
my $secret = '}bZ[o8@?aR:k`/kO+_T2.H1.gf6bsF8OM';

sub add {
    my ( $self, $email ) = @_;

    my $hash = JSON::WebToken->encode(
        {
            email => $email,
        },
        $secret,
    );

    my $signup;

    try {
        $self->schema->txn_do(
            sub {
                my $obj = $self->list({email => $email});

                die "Cannot use that email address.\n" if ( $obj and @$obj );

                $signup = $self->resultset->create({
                    email => $email,
                    hash  => $hash,
                });
            }
        );
    }
    catch {
        die $_;
    };

    return $self->deflate($signup);
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
