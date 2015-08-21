package TankTracker::Controller::User::Access;
use Moose;
use namespace::autoclean;

use Try::Tiny;

BEGIN { extends q{Catalyst::Controller::HTML::FormFu} }

with q{TankTracker::TraitFor::Controller::User};

sub auto :Private {
    my ($self, $c) = @_;

    $c->stash->{'page_title'} = 'Tank Access';
    $c->stash->{'active_tab'} = 'access';
    $c->stash->{'template_wrappers'} = [];

    return 1;
}

sub _search_access {
    my ($self, $c) = @_;

    my $elements = [
        {
            name    => 'by_tank',
            type    => 'Hidden',
            value   => 0,
        },
    ];

    return { elements => $elements };
}

sub _list_by_user :Private {
    my ($self, $c, $page, $user_id) = @_;

    my ( $users, $pager ) = @{ $c->model('User')->list(
        {
            parent_id    => $user_id,
            'me.active'  => 1,
            # don't include the logged-in user, they always get access to
            # all their tanks...
            'me.user_id' => { '!=' => $user_id },
        },
        {
            prefetch => { 'tank_user_accesses' => 'tank' },
            columns  => [ qw( user_id first_name last_name ) ],
            order_by => { '-asc' => [ 'first_name', 'last_name' ] },
            page     => $page || 1,
            rows     => $c->stash->{'user'}{'preferences'}{'recs_per_page'} || 10,
        },
    ) };

    for my $user ( @{ $users } ) {
        my $tanks = delete $user->{'tank_user_accesses'};
        for my $access ( @{ $tanks } ) {
            my $tank = delete $access->{'tank'};

            ## Just sanity check before we merge the user data hash into
            ## the tank_user_accesses record (it's highly unlikely that
            ## this would ever occur).
            if ( $tank->{'tank_id'} != $access->{'tank_id'} ) {
                ## FIXME: handle this more gracefully...
                die "**** INTERNAL ERROR!!!! BAD TANK_ID IN ACCESS!!";
            }

            $access = {
                %{ $access },
                %{ $tank   }, # <= this will overwrite tank_id key, that's ok!
            };
        }
        $user->{'access'} = $tanks;
    }

    return [ $users, $pager ];
}

sub _list_by_tank :Private {
    my ($self, $c, $page, $user_id) = @_;

    my ( $tanks, $pager ) = @{ $c->model('Tank')->list(
        {
            parent_id   => $user_id,
            'me.active' => 1,
        },
        {
            ## FIXME: either figure out how to select columns from the
            ##        prefetched data, or else sanitise what we're getting
            ##        here... we don't need password, etc.
            columns  => [ qw(tank_id tank_name water_type) ],
            prefetch => { 'tank_user_accesses' => 'tracker_user' },
            order_by => { '-asc' => [ 'tank_name' ] },
            page     => $page || 1,
            rows     => $c->stash->{'user'}{'preferences'}{'recs_per_page'} || 10,
        })
    };

    for my $tank ( @{ $tanks } ) {
        my $tanks = delete $tank->{'tank_user_accesses'};
        for my $access ( @{ $tanks } ) {
            my $user = delete $access->{'tracker_user'};

            ## Just sanity check before we merge the user data hash into
            ## the tank_user_accesses record (it's highly unlikely that
            ## this would ever occur).
            if ( $user->{'user_id'} != $access->{'user_id'} ) {
                ## FIXME: handle this more gracefully...
                die "**** INTERNAL ERROR!!!! BAD USER_ID IN ACCESS!!";
            }

            $access = {
                %{ $access },
                %{ $user   }, # <= this will overwrite user_id key, that's ok!
            };
        }
        $tank->{'access'} = $tanks;
    }

    return [ $tanks, $pager ];
}

sub list: Chained('get_user') PathPart('access/list') FormMethod('_search_access') {
    my ( $self, $c, $page ) = @_;

    my $form    = $c->stash->{'form'};
    my $by_tank = $c->session->{'access_by_tank'};

    if ( $form->submitted_and_valid() ) {
        $by_tank = $form->param('by_tank');
        $c->session->{'access_by_tank'} = $by_tank;
    }

    my $user_id = $c->stash->{'user'}{'user_id'};

    my $action = '_list_by_'.($by_tank ? 'tank' : 'user');
    my $access = $c->forward($action, [ $page, $user_id ]);

    my ( $list, $pager ) = @{ $access };

    if ( $pager and ref($pager) ) {
        $pager->{'what'} = $by_tank ? 'tanks' : 'users';
        $pager->{'path'} = [ '/user', $user_id, 'access/list' ];
    }

    # set up the 'edit' action for each record:
    for my $rec ( @{ $list } ) {
        my $what = $by_tank ? 'tank' : 'user';
        my $id   = $rec->{"${what}_id"};

        $rec->{'edit_url'} = [ '/user', $user_id, 'access/edit', $what, $id ];
    }

    $c->stash->{'by_tank'} = $c->session->{'access_by_tank'};
    $c->stash->{'list'}    = $list;
    $c->stash->{'pager'}   = $pager;

    return 1;
}

sub _user_access_form :Private {
    my ( $self, $c, $user_id ) = @_;

    my $user = $c->model('User')->get($user_id);

    $c->stash->{'page_title'} = sprintf(
        '%s %s - Tank Access',
        $user->{'first_name'},
        $user->{'last_name'},
    );

    my $parent_id = $user->{'parent_id'} || $user_id;

    ## List of all available tanks which are owned by this
    ## user's parent:
    my $all_tanks = $c->model('Tank')->list(
        {
            owner_id => $parent_id,
        },
        {
            columns  => [ qw{ tank_id tank_name water_type owner_id } ],
            order_by => { '-asc' => [ qw( water_type tank_name ) ] },
        },
    );

    ## Tanks which user currently has access to:
    my $user_tanks = $c->model('UserTank')->list(
        {
            user_id => $user_id,
        },
    );

    my %has_tank_access = ();

    for my $tank ( @{ $user_tanks } ) {
        $has_tank_access{$tank->{'tank_id'}} = { 'admin' => $tank->{'admin'} };
    }

    my $elements = [];

    for my $tank ( @{ $all_tanks } ) {
        push @$elements,
        {
            type    => 'Checkbox',
            name    => 'access',
            id      => "access_$tank->{'tank_id'}",
            value   => $tank->{'tank_id'},
            label   => sprintf('%s (%s)',
                            $tank->{'tank_name'},
                            $tank->{'water_type'},
                       ),
            default => exists $has_tank_access{$tank->{'tank_id'}}
                       ? $tank->{'tank_id'}
                       : 0,
        },
        {
            type    => 'Checkbox',
            name    => 'admin',
            id      => "admin_$tank->{'tank_id'}",
            value   => $tank->{'tank_id'},
            default => exists $has_tank_access{$tank->{'tank_id'}}
                       ? $has_tank_access{$tank->{'tank_id'}}{'admin'}
                       : 0,
        }
        ;
    }

    return { elements => $elements };
}

sub _tank_access_form :Private {
    my ( $self, $c, $tank_id ) = @_;

    my $tank = $c->model('Tank')->get($tank_id);

    $c->stash->{'page_title'} = sprintf(
        '%s (%s) - User Access',
        $tank->{'tank_name'},
        $tank->{'water_type'},
    );

    my $parent_id = $tank->{'owner_id'};

    ## List of all available users which are parented by this
    ## tank's owner:
    my $all_users = $c->model('User')->list(
        {
            parent_id => [ $parent_id, 1, undef ],
        },
        {
            columns  => [ qw{ user_id first_name last_name parent_id } ],
            order_by => { '-asc' => [ 'username' ] },
        },
    );

    my $users = $c->model('User')->list(
        {
            parent_id => $parent_id,
        },
        {
            columns  => [ qw{ user_id first_name last_name } ],
            order_by => { '-asc' => [ 'first_name', 'last_name' ] },
        },
    );

    ## User which currently have access to this tank:
    my $user_tanks = $c->model('UserTank')->list(
        {
            tank_id => $tank_id,
        },
    );

    my %has_tank_access = ();

    for my $user ( @{ $user_tanks } ) {
        $has_tank_access{$user->{'user_id'}} = { 'admin' => $user->{'admin'} };
    }

    my $elements = [];

    for my $user ( @{ $all_users } ) {
        push @$elements,
        {
            type    => 'Checkbox',
            name    => 'access',
            id      => "access_$user->{'user_id'}",
            value   => $user->{'user_id'},
            label   => $user->{'first_name'}.' '.$user->{'last_name'},
            default => exists $has_tank_access{$user->{'user_id'}}
                       ? $user->{'user_id'}
                       : 0,
        },
        {
            type    => 'Checkbox',
            name    => 'admin',
            id      => "admin_$user->{'user_id'}",
            value   => $user->{'user_id'},
            default => exists $has_tank_access{$user->{'user_id'}}
                       ? $has_tank_access{$user->{'user_id'}}{'admin'}
                       : 0,
        }
        ;
    }

    return { elements => $elements };
}

sub edit :Chained('get_user') PathPart('access/edit') Args(2) {
    my ( $self, $c, $mode, $id ) = @_;

    # manually construct form (can't pass args using FormMethod)
    my $form = $self->form();
    $form->populate($c->forward("_${mode}_access_form", [ $id ]));
    $form->process();
    $c->stash->{form} = $form;

    if ( $form->submitted_and_valid() ) {
        try {
            $c->model('Access')->update({
                mode   => $mode,
                id     => $id,
                access => $form->param_array('access'),
                admin  => $form->param_array('admin'),
            });
            $c->stash->{'message'} = 'Updated tank access ok';
        }
        catch {
            $c->log->fatal("access update() failed: $_");
            $c->error($_);
            $c->detach();
            return;
        };

        # return to the Access list after successful update:
        my $user_id = $c->stash->{'user'}{'user_id'};
        $c->response->redirect($c->uri_for(qq{/user/$user_id/access/list}));
        $c->detach();
        return;
    }

    return;
}

__PACKAGE__->meta->make_immutable;

1;
