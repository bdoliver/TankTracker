package HTML::FormFu::Validator::TankTracker::UserExists;

use Moose;
extends 'HTML::FormFu::Validator';

sub validate_value {
    my ( $self, $value, $params ) = @_;

    my $c = $self->form->stash->{context};

    # sanity check:
    $value or die HTML::FormFu::Exception::Validator->new({
        message => q{username cannot be blank},
    });

    my @users = $c->model('User')->search({username => $value})->all();

    if ( @users ) {
        die HTML::FormFu::Exception::Validator->new({
            message => qq{Cannot use username '$value': it is already taken},
        });
    }

    return 1;
}

1;

