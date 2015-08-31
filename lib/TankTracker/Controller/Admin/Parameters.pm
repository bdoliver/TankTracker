package TankTracker::Controller::Admin::Parameters;
use Moose;
use namespace::autoclean;

use Try::Tiny;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu' }

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{'page_title'} = 'Water Test Parameters - Default Settings';
    $c->stash->{'active_tab'} = 'params';

    return 1;
}

sub base :Chained('/') :PathPart('admin') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    return 1;
}

sub _parameter_form :Private {
    my ($self, $c) = @_;

    my $params = $c->model('WaterTestParameter')->list(
        {},
        { 'order_by' => { '-asc' => 'parameter_id' }, },
    );

    my @elements = ();

    for my $param ( @{ $params } ) {
        push @elements,
        {
            name  => "parameter_id",
            type  => 'Hidden',
            value => $param->{'parameter_id'},
        },
        {
            name  => "parameter",
            type  => 'Hidden',
            value => $param->{'parameter'},
        },
        {
            name  => "title",
            type  => 'Text',
            value => $param->{'title'},
            constraints => [
                'Required',
            ]
        },
        {
            name  => "label",
            type  => 'Text',
            value => $param->{'label'},
            constraints => [
                'Required',
            ]
        },
        {
            name  => "rgb_colour",
            type  => 'Text',
            value => $param->{'rgb_colour'},
            constraints => [
                'Required',
                {
                    type => 'Regex',
                    regex => '^#[\da-fA-F]{6}$',
                },
            ]
        },
    }

    return { 'elements' => \@elements };
}

sub params : Chained('base') :PathPart('parameters') Args(0) FormMethod('_parameter_form') {
    my ($self, $c) = @_;

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $params = $form->params();

        my @params = ();

        for my $i ( 0 .. $#{$params->{'parameter_id'}} ) {
            push @params,
            {
                parameter_id => $params->{'parameter_id'}[$i],
                title        => $params->{'title'}[$i],
                label        => $params->{'label'}[$i],
                rgb_colour   => $params->{'rgb_colour'}[$i],
            };
        }

        try {
            $c->model('WaterTestParameter')->update(\@params);
            $c->flash->{'message'} = q{Saved parameters ok};

            # Because of the way in which the form is constructed,
            # we need to do an external redirect back to ourself
            # in order to re-display the newly-saved values:
            $c->response->redirect($c->uri_for(qq{/admin/parameters}));
            $c->detach();
            return;
        }
        catch {
            my $err = qq{Error saving parameters: $_};
            $c->stash->{'error'} = $err;
        };
    }

    if ( my $msg = $c->flash->{'message'} ) {
        $c->stash->{'message'} = $msg;
    }

    $c->stash->{'template'} = 'admin/parameters.tt';

}


__PACKAGE__->meta->make_immutable;

1;
