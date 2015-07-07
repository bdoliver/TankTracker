package TankTracker::Controller::User::Access;
use Moose;
use namespace::autoclean;

use Try::Tiny;

BEGIN { extends q{Catalyst::Controller::HTML::FormFu} }

with q{TankTracker::TraitFor::Controller::User};

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{'page_title'} = 'Access';
    $c->stash->{'active_tab'} = 'access';

    return 1;
}

sub list: Chained('get_user') :PathPart('access/list') {
    my ( $self, $c, $page ) = @_;

    my $user_id = $c->stash->{'user'}{'user_id'};

    my ( $tanks, $pager ) = @{ $c->model('Access')->list(
        {
            user_id => $user_id,
        },
        {
#             order_by => { '-asc' => 'tank_name' },
            page     => $page || 1,
            rows     => $c->stash->{'user'}{'preferences'}{'recs_per_page'} || 10,
        },
    ) };
use Data::Dumper;
warn "\n\nACCESS:\n", Dumper($tanks);
#
#     if ( $pager and ref($pager) ) {
#         $pager->{'what'} = 'water tests';
#         $pager->{'path'} = [ '/tank', $tank_id, 'water_test/list' ];
#     }
#
#     $c->stash->{'tests'} = $tests;
#     $c->stash->{'pager'} = $pager;
#
#     $c->stash->{'action_heading'} = 'Water Tests';
#
#     $c->stash->{'add_url'}    = qq{/tank/$tank_id/water_test/add};
#     $c->stash->{'chart_url'}  = qq{/tank/$tank_id/water_test/chart};
#     $c->stash->{'export_url'} = qq{/tank/$tank_id/water_test/tools/export};
#     $c->stash->{'import_url'} = qq{/tank/$tank_id/water_test/tools/import};

    return 1;

}
#
# sub add : Chained('base') :PathPart('add') Args(0) {
#     my ( $self, $c ) = @_;
#
#     $c->stash->{tank_action}    = 'add';
#     $c->stash->{action_heading} = 'Add';
#
#     $c->forward('details');
#
#     return;
# }
#
# sub edit : Chained('get_user') :PathPart('edit') Args(0) {
#     my ( $self, $c ) = @_;
#
#     $c->stash->{tank_action}    = 'edit';
#     $c->stash->{action_heading} = 'Edit';
#
#     $c->forward('details');
#
#     return;
# }
#
# ## FIXME: do we really need this one?
# sub view : Chained('get_user') Args(0) {
#     my ( $self, $c ) = @_;
#
#     $c->stash->{tank_action}    = 'view';
#     $c->stash->{action_heading} = 'Details';
#
#     $c->forward('details');
# }
#
# sub details :Local Args(0) FormMethod('_details') {
#     my ( $self, $c ) = @_;
#
#     my $form = $c->stash->{'form'};
#
#     if ( $form->submitted_and_valid() ) {
#         my $params = $form->params();
#
#         delete $params->{'submit'};
#
#         # need to split preferences from user attributes
#         my $prefs = {};
#
#         for my $pref ( qw(capacity_units
#                           dimension_units
#                           temperature_scale
#                           recs_per_page) ) {
#             $prefs->{$pref} = delete $params->{$pref};
#         }
#
#         try {
#             $c->model('User')->update($c->user->user_id(), $params, $prefs);
#             $c->stash->{'message'} = q{Updated user details.};
#         }
#         catch {
#             my $error = qq{Error saving user details: $_};
#             $c->log->error($error);
#             $c->stash->{'error'} = $error;
#         };
#     }
#
#     $form->default_values({
#         'first_name' => $c->user->first_name(),
#         'last_name'  => $c->user->last_name(),
#         'email'      => $c->user->email(),
#         %{ $c->stash->{'user'}{'preferences'} },
#     }) if ! $form->submitted();
#
#     $c->stash->{'action_heading'} = 'Details';
#     $c->stash->{'template'} = 'user/details.tt2';
#
#     return;
# }

__PACKAGE__->meta->make_immutable;

1;
