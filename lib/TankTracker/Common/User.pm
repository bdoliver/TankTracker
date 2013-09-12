#!/bin/env perl

package TankTracker::Common::User;

use strict;
use warnings;

use base qw( Exporter );

use Dancer ':syntax';
use Dancer::Plugin::DBIC 'schema';
# Although we are using the ::Auth::RBAC::Credentials::DBIC plugin,
# we need to load the core RBAC module to get the auth() method
use Dancer::Plugin::Auth::RBAC;

use Data::Dumper;

use TankTracker::Common::Utils qw(set_error);

our @EXPORT_OK = qw(search_users
                    edit_user
                    add_user
                    do_login
                   );

sub do_login {
    my $args  = shift;

    my $login = $args->{login};
    my $pass  = $args->{password};

    my $auth  = auth($login, $pass);

    my $path;

    # Validate the user login
    if ( $login and $pass and authd() ) {
        session logged_in => 1;

        my $user = schema->resultset('TrackerUser')->find({login => $login});

        if ( $user->active() ) {
            session user_id => $user->user_id();
            #session role_id => $user->role_id();
            $path = $args->{path} || '/';
        }
        else {
            # cannot login as an inactive user
            set_error("Login failed");

            $path = '/login';
        }
    }
    else {
        set_error("Login failed");

        $path = '/login';
    }
print STDERR "do_login() returning path=$path\n";
    return $path;
}

# sub search_users {
#     my $args = shift || {};
# 
#     if ( exists $args->{searchField} ) {
#          my $search_field = $args->{searchField};
#          if ( $search_field ) {
#             $args->{searchField} = 'role_name' if
#                                         $search_field eq 'role';
#         }
#     }
# 
#     my $search = build_gridSearch($args);
# 
#     my $sort_col = $args->{sidx} || 'user_id';
#     my $sort_ord = $args->{sord} || 'asc';
# 
#     $sort_col = 'me.user_id' if $sort_col eq 'user_id';
# 
#     my $page = $args->{page} || 1;
#     my $rows = $args->{rows} || 10;
# 
#     return schema->resultset('AuditUser')
#                  ->search($search,
#                           { prefetch => [ 'audit_user_roles'],
#                             order_by => { "-$sort_ord" => $sort_col },
#                             page     => $page,
#                             rows     => $rows,
#                           });
# }
# 
# sub update_roles {
#     my ( $user, $updated_roles ) = @_;
# 
#     ( $updated_roles and @$updated_roles ) or return undef;
# 
#     my %current_roles = ();
# 
#     if ( $user->roles() ) {
#          %current_roles = map { $_->role_id() => 1 } $user->roles();
#     }
# 
#     my $user_id = $user->user_id();
# 
#     for my $role_id ( @$updated_roles ) {
#         if ( exists $current_roles{$role_id} ) {
#             # user already has $role_id
#             delete $current_roles{$role_id};
#             next;
#         }
# 
#         #user doesn't have this role, so assign it
#         my $user_role = schema->resultset('AuditUserRole')
#                               ->create({user_id => $user_id,
#                                         role_id => $role_id});
#         eval { $user_role->update()->discard_changes(); };
# 
#         die "Error assigning role #$role_id to user #$user_id: $@\n" if $@;
#     }
# 
#     ## whatever is left in %current_roles are roles that are no longer
#     ## assigned to the user, so delete them
#     for my $old_role ( keys %current_roles ) {
#         schema->resultset('AuditUserRole')->find({user_id => $user_id,
#                                                   role_id => $old_role})
#                                           ->delete();
#     }
# 
#     1;
# }
# 
# sub edit_user {
#     my $args    = shift or return;
#     my $user_id = $args->{user_id};
#     my $user    = schema->resultset('AuditUser')->find($user_id);
# 
#     $user or die "User #$user_id not found in database!\n";
# 
#     $user->login($args->{login})         if $args->{login};
#     $user->user_name($args->{user_name}) if $args->{user_name};
#     $user->email($args->{email})         if $args->{email};
# 
#     if ( $args->{password} ) {
#         my $hash_pw = $user->hash_pw($args->{password}); 
# 
#         if ( $hash_pw ne $user->password() ) {
#             # password has changed - update it 
#             $user->password($hash_pw);
#         }
#     }
# 
#     my $active = $args->{active};
#     $user->active( ($active and $active =~ m|^yes$|i) ? 1 : 0 );
# 
#     eval { $user->update(); };
# 
#     if ( $@ ) {
#         my $e = "edit_user() failed: $@\nargs:\n".Dumper($args);
#         die $e;
#     }
# 
#     ## update user's roles:
#     if ( $args->{roles} ) {
#         eval { update_roles($user, [ split(',',$args->{roles}) ]); };
# 
#         if ( $@ ) {
#             my $e = "edit_user() update_roles() failed: $@\nargs:\n".Dumper($args);
#             die $e;
#         }
#     }
# }
# 
# sub add_user {
#     my $args  = shift or return;
#     my $roles = delete $args->{roles};
#     my $pass  = $args->{password};
#     my $user  = schema->resultset('AuditUser')->create($args);
# 
#     $user->password($user->hash_pw($pass));
# 
#     eval { $user->update()->discard_changes(); };
# 
#     if ( $@ ) {
#         ## re-instate the original arg hash:
#         $args->{roles} = $roles;
#         my $e = "add_user() failed: $@\nargs:\n".Dumper($args);
#         die $e;
#     }
# 
#     ## update user's roles:
#     if ( $roles ) {
#         eval { update_roles($user, [ split(',',$roles) ]); };
# 
#         if ( $@ ) {
#             ## re-instate the original arg hash:
#             $args->{roles} = $roles;
#             my $e = "add_user() update_roles() failed: $@\nargs:\n".Dumper($args);
#             die $e;
#         }
#     }
# }

1;