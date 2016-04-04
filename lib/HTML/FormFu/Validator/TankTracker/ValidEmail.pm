package HTML::FormFu::Validator::TankTracker::ValidEmail;

use Moose;
use Email::Valid;

extends 'HTML::FormFu::Validator';

sub validate_value {
    my ( $self, $value, $params ) = @_;

    my $c = $self->form->stash->{context};

    # sanity check:
    $value or die HTML::FormFu::Exception::Validator->new({
        message => q{email cannot be blank},
    });

    my $ret;

    eval {
        $ret = Email::Valid->address(
            '-address' => $value,
            '-mxcheck' => 1,
        );
    };

    my $err = $@;

    if ( not $ret and not $err ) {
        $err = qq{'$value' is not a valid email address};
    }

    if ( $err ) {
        die HTML::FormFu::Exception::Validator->new({
            message => qq{Email validation failed: $err},
        });
    }

    return $ret;
}

1;

