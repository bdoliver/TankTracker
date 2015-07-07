package TankTracker::Controller::Tank::WaterTest::Tools;
use Moose;
use namespace::autoclean;

use DateTime;
use File::Path;
use JSON;
use Try::Tiny;

BEGIN { extends q{Catalyst::Controller::HTML::FormFu} }

with q{TankTracker::TraitFor::Controller::Tank};

sub _tools :Private {
    my ($self, $c, $action) = @_;

    ( $action =~ qr{ \A (?:im|ex)port \z}msx ) or
        die "Invalid tools action '$action'";

    $c->stash->{'tools_action'}   = $action;
    $c->stash->{'action_heading'} = q{Test Results - }.ucfirst($action);

    $c->stash(template => qq{tank/watertest/tools/$action.tt2});

    return;
}

sub _export_form :Private {
    my ($self, $c ) = @_;

    my $tank_id = $c->stash->{'tank'}{'tank_id'};

    my $elements = [
        {
            type  => 'Radiogroup',
            name  => 'export_all',
            label => 'Export for which tank?',
            default => '0',
            label_tag => 'label',
            label_attributes => { for => 'tank_action' },
            options => [
                [ '0' => 'Currently selected tank' ],
                [ '1' => 'All tanks owned by you' ],
            ],
            constraints => [
                'AutoSet',
                'Required',
            ],
        },
        {
            name  => 'start_date',
            type  => 'Text',
        },
        {
            name  => 'end_date',
            type  => 'Text',
            default => DateTime->now()->strftime('%Y-%m-%d'),
        },
        {
            type => 'Submit',
            name => 'submit',
        },
    ];

    return { 'elements' => $elements };
}

sub export :Chained('get_tank') PathPart('water_test/tools/export') Args(0) FormMethod('_export_form') {
    my ($self, $c ) = @_;

    # set generic import/export stash options:
    $c->forward('_tools', ['export']);

    $c->stash->{'col_width'} = 4;

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {
        my $search = {};
        my $order  = {
            order_by   => [ qw(tank_id test_date) ],
            no_deflate => 1, # we want the raw resultset for export
        };

        my $export_file = q{water_tests};

        if ( $form->param('all') ) {
            ## If user wants all tanks, we can just select on water_test
            ## with the current user ID - we could miss tests logged by
            ## other users.  Instead, we lookup all tanks owned by the
            ## current user.

            $search->{'tank.owner_id'} = $c->user->user_id();
            $order->{'join'} = 'tank';

            $export_file .= q{-all_tanks};
        }
        else {
            $search->{'tank_id'} = $c->stash->{'tank'}{'tank_id'};
            $export_file .= "-tank_$search->{'tank_id'}";
        }

        my $start = $form->param('start_date');
        my $end   = $form->param('end_date');

        if ( $start or $end ) {
            my @and = ();

            if ( $start ) {
                push @and,
                    [ 'test_date' => { '>=', $start } ];

                $export_file .= $end ? "-$start" : "-from_$start";
            }

            if ( $end ) {
                push @and,
                    [ 'test_date' => { '<=', $end } ];

                $export_file .= $start ? "-$end" : "-to_$end";
            }

            $search->{'-and'} = \@and;
        }
        else {
            $export_file .= q{-all_dates};
        }

        $export_file =~ s{/}{}g;

        my $tests = $c->model('WaterTest')->list($search, $order);

        $c->stash( columns      => [ $c->model('WaterTest')->columns() ],
                   cursor       => $tests->cursor(),
                   current_view => 'CSV',
                   filename     => "$export_file.csv",
        );
    }
}

sub _import_form :Private {
    my ($self, $c ) = @_;

    my $tank_id = $c->stash->{'tank'}{'tank_id'};

    my $elements = [
        {
            name => 'import_file',
            type => 'File',
            attributes => {
                'id' => 'import_file',
                'data-preview-file-type' => 'text',
                'data-wrap-text-length' => 45,
            },
            constraints => [ 'Required' ],
        },
        {
            type => 'Submit',
            name => 'submit',
        },
    ];

    return { 'elements' => $elements };
}

sub import :Chained('get_tank') PathPart('water_test/tools/import') Args(0) FormMethod('_import_form') {
    my ($self, $c ) = @_;

    $c->forward('_tools', ['import']);

    $c->stash->{'col_width'} = 8;

    my $form = $c->stash->{'form'};

    if ( $form->submitted_and_valid() ) {

##FIXME: check out w.r.t limiting/aborting upload based on file size...
## http://stackoverflow.com/questions/3090574/how-to-cancel-a-file-upload-based-on-file-size-in-catalyst
        if ( my $upload = $c->request->upload('import_file') ) {
            my $file   = $upload->filename();
            my $target = qq{/tmp/tt_imports/$file};

            ( $upload->link_to($target) || $upload->copy_to($target) ) or
                die "Failed to copy '$file' to '$target': $!";

            try {
                my $result = $c->model('WaterTest')->load_tests({
                    tank_id => $c->stash->{'tank'}{'tank_id'},
                    user_id => $c->user->user_id(),
                    fh      => $upload->decoded_fh(),
                });

                $c->stash->{'import_result'} = $result;
            }
            catch {
                $c->stash->{'import_error'} = $_;
            };
        }
    }
}

=encoding utf8

=head1 AUTHOR



=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
