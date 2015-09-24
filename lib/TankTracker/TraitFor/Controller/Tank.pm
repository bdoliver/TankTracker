package TankTracker::TraitFor::Controller::Tank;

use MooseX::MethodAttributes::Role;
use namespace::autoclean;

use File::Path qw(make_path);

sub base :Chained('/') :PathPart('tank') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

    if ( $c->request->path() =~ qr{tank/.+} ) {
        $c->stash->{'back_link'} = {
            'path' => '/tank',
            'text' => 'Back',
        };
    }

    return 1;
}

sub get_tank :Chained('base') :PathPart('') CaptureArgs(1) {
    my ( $self, $c, $tank_id ) = @_;

    if ( ! $tank_id ) {
        my $error = qq{Missing tank_id!};
        $c->log->fatal("get_error() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( $tank_id !~ qr{\A \d+ \z}msx ) {
        my $error = qq{Invalid tank_id '$tank_id'!};
        $c->log->fatal("get_tank() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    if ( my $tank = $c->model('Tank')->get($tank_id) ) {
        if ( $c->user->user_id() != $tank->{'owner_id'} ) {
            my $error = qq{Tank requested '$tank_id': does not belong to current user!};
            $c->log->fatal("get_error() $error");
            $c->error($error);
            $c->detach();
            return;
        }


        # Make sure we have the photo dir for this tank:
        my $photo_dir = $c->forward('photo_dir', [ $tank_id ]);

        if ( $photo_dir and @{ $tank->{'photos'} } ) {
            my $uri = $c->uri_for($c->config->{'photo_root'}."/$tank_id");

            my $idx = 0;
            # prefix each photo with the uri path to it:
            map { $_->{'file_name'} = $uri."/".$_->{'file_name'};
                  $_->{'slide_to'}  = $idx++;
            } @{ $tank->{'photos'} };
        }

        $c->stash->{'tank'} = $tank;
    }
    else {
        my $error = qq{Tank requested '$tank_id': not found in database!};
        $c->log->fatal("get_tank() $error");
        $c->error($error);
        $c->detach();
        return;
    }

    return 1;
}

sub photo_dir :Private {
    my ( $self, $c, $tank_id ) = @_;

    # Make sure we have the photo dir for this tank:
    my $tank_photo_dir = $c->path_to('./root')
                         .$c->config->{'photo_root'}
                         ."/$tank_id";

    if ( ! -d $tank_photo_dir ) {
        my $err = undef;
        make_path(
            $tank_photo_dir,
            {
                'verbose' => 0,
                'mode'    => 0755,
                'error'   => \$err,
            }
        );

        # make_path() sets $err as an array ref, but we will check
        #             anyway, just to be sure!

        if ( $err and ref($err) eq 'ARRAY' and @$err ) {
            warn "\nError creating photo path ($tank_photo_dir): "
                 .join("\n", @$err)
                 ."\n\n";
            $tank_photo_dir = undef;
        };
    }

    return $tank_photo_dir;
}

1;
