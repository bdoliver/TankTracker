package HTML::FormFu::Validator::TankTracker::EmailExists;

use Moose;
extends 'HTML::FormFu::Validator';

sub validate_value {
    my ( $self, $value, $params ) = @_;

    my $c = $self->form->stash->{context};

    # sanity check:
    $value or die HTML::FormFu::Exception::Validator->new({
        message => q{email cannot be blank},
    });

    if ( exists $c->stash->{'user'}     and
         $c->stash->{'user'}->{'email'} and
         $c->stash->{'user'}->{'email'} eq $value ) {
        # current user updating own details is ok if their email address
        # has not changed:
        return 1;
    }

    my @users = $c->model('User')->search({email => $value})->all();

    if ( @users ) {
        die HTML::FormFu::Exception::Validator->new({
            message => qq{Cannot use email address '$value': it is already taken},
        });
    }

    return 1;
}

1;

