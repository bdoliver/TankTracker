#!/usr/bin/env perl

use strict;
use warnings;

use DBICx::Sugar qw(schema);

use Encode;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use Getopt::Long qw(:config no_ignore_case bundling);
use Pod::Usage;
use Try::Tiny;

use TankTracker::Schema::TrackerUser;

our ( $add, $edit, $user, $pass, $email, $first_name, $last_name,
      $parent_id, $active, $help );

Getopt::Long::GetOptions(
    'user=s'       => \$user,
    'pass=s'       => \$pass,
    'email=s'      => \$email,
    'first_name=s' => \$first_name,
    'last_name=s'  => \$last_name,
    'add'          => \$add,
    'parent_id=i'  => \$parent_id,
    'active=i'     => \$active,
    'help|?'       => \$help,
);

pod2usage( -verbose => 2) if $help;

DBICx::Sugar::config(
    { default => { dsn => "dbi:Pg:dbname=TankTracker", schema_class => 'TankTracker::Schema'} },
);

$user or
    pod2usage(
        -message => "Missing --user=user_first_name (mandatory)\n",
        -exitval => 1,
        -verbose => 1,
    );

if ( $add ) {
    $email or
        pod2usage(
            -message => "--email 'email\@example.com' mandatory for new a/c\n",
            -exitval => 1,
            -verbose => 1,
        );

    $pass or
        pod2usage(
            -message => "--pass XXXX mandatory for new a/c\n",
            -exitval => 2,
            -verbose => 1,
        );
    $parent_id or
        pod2usage(
            -message => "--parent_id XXXX mandatory for new a/c\n",
            -exitval => 2,
            -verbose => 1,
        );
}
else {
    ( $email or $user ) or
        pod2usage(
            -message => "Need at least one of --email or --user when editing a user.\n",
            -exitval => 1,
            -verbose => 1,
        );
}

my $schema = schema;

my $rs = $schema->resultset('TrackerUser');

if ( $add ) {
    ## create user:
    my $hash = TankTracker::Schema::TrackerUser->hash_pw($pass);
    Encode::from_to($hash, "iso-8859-1", "utf8");

    try {
        $schema->txn_do(
            sub {
                my $user = $rs->create({
                    username   => $user,
                    email      => $email,
                    password   => $hash,
                    first_name => $first_name,
                    last_name  => $last_name,
                    parent_id  => $parent_id,
                    active     => $active,
                });

                $user->update() or
                    die "Failed to save new user\n";

                my $prefs = $schema->resultset('UserPreference')->create({
                    user_id              => $user->user_id(),
                    recs_per_page        => 10,
                    tank_order_col       => 'tank_id',
                    tank_order_seq       => 'asc',
                    water_test_order_col => 'test_id',
                    water_test_order_seq => 'desc',
                });

                $prefs->update() or
                     die "Failed to create preferences for new user\n";

                print "User created\n";
            }
        );
    }
    catch {
        die $_;
    };
}
else {
    try {
        my $user = $rs->find({username => $user});

        $user or die "Cannot find user '$user' in database!\n";

        $user->email($email)                   if $email;
        $user->first_name($first_name)         if $first_name;
        $user->last_name($last_name)           if $last_name;
        $user->password($user->hash_pw($pass)) if $pass;
        $user->active($active)                 if defined $active;
        $user->parent_id($parent_id)           if $parent_id;

        $user->update() or die "Failed to update user\n";

        print "User updated\n";
    }
    catch {
        die $_;
    };
}

exit(0);
__END__

=pod

=head1 NAME

user_admin.pl - Administer TankTracker user details.

=head1 SYNOPSIS

user_admin.pl [--add|--del] --user XXX ...

=head1 ARGUMENTS

=over

=item --help|?

This documentation.

=item --add

Add a new user to the system.  Without this option, edits an existing
user.

=item --del

Deletes given user.  NB: You cannot delete a user who still has tests
and / or tanks associated with them.  You must transfer those details
to another user before deletion can proceed.  Script will terminate
with an exception if the user still has database records associated.

=item --user XXX

Specifies user id (C<XXX>) to add / edit / delete (mandatory).

=item --pass XXX

Password for user (mandatory when adding, otherwise sets new user password).

=item --email XXX

Email address for user (mandatory when adding new user)

=item --first_name XXX

User's first name.

=item --last_name XXX

User's last name.

=item --parent_id

The user_id of the user to which the current user 'belongs'.
(mandatory when adding new user)

=item --active 1|0

Acivate / de-activate user.  This is optional when adding a new user as new
users are always activated.

=back

=cut


