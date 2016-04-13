package HTML::FormFu::Validator::TankTracker::ValidPassword;

use Moose;
use Data::Password::Check;
use Try::Tiny;

extends 'HTML::FormFu::Validator';

sub validate_value {
    my ( $self, $value, $params ) = @_;

    my $c = $self->form->stash->{context};

    try {
        # sanity check:
        $value or die q{new password cannot be blank};

        my $reset_code = $params->{'reset_code'} or
            die q{reset code is missing};

        # we need the user who owns this reset request:
        my $user = $c->model('User')->get_by_reset_code($reset_code);

        $user or
            die q{this reset request is not owned by any user};

        my $pwcheck = Data::Password::Check->check({
            'password'   => $value,
            'min_length' => 8,
            'tests'      => [
                'length',
                'diverse_characters',
                'silly',
                'repeated',
            ],
            'silly_words_append' => [
                $user->{username},
                $user->{email},
                $user->{password},
                reverse $user->{username},
                reverse $user->{email},
                reverse $user->{password},
            ],

        });

        if ( $pwcheck->has_errors() ) {
            die join("\n", @{ $pwcheck->error_list() } );
        }
    }
    catch {
        die HTML::FormFu::Exception::Validator->new({
            message => qq{Password reset failed: $_},
        });

    };

    return 1;
}

1;

