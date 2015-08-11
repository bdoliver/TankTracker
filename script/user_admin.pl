#!/usr/bin/env perl

use strict;
use warnings;

use DBICx::Sugar qw(schema);

use Encode;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use Getopt::Long qw(:config no_ignore_case bundling);

use TankTracker::Schema::TrackerUser;

our ( $add, $edit, $user, $pass, $email, $first_name, $last_name, $parent_id );

Getopt::Long::GetOptions(
    'user=s'       => \$user,
    'pass=s'       => \$pass,
    'email=s'      => \$email,
    'first_name=s' => \$first_name,
    'last_name=s'  => \$last_name,
    'add'          => \$add,
    'parent_id=i'  => \$parent_id,
);

DBICx::Sugar::config(
    { default => { dsn => "dbi:Pg:dbname=TankTracker", schema_class => 'TankTracker::Schema'} },
);

$user or die "Missing --user=user_first_name (mandatory)\n";

if ( $add ) {
    $email or die "--email 'email\@example.com' mandatory for new a/c\n";
    $pass  or die "--pass XXXX mandatory for new a/c\n";
}
else {
    ( $email or $pass or $first_name ) or
            die "Need at least one of --email, --pass or --first_name when editing a user.\n";
}

my $schema = schema;

my $rs = $schema->resultset('TrackerUser');

if ( $add ) {
    ## create user:
    my $hash = TankTracker::Schema::TrackerUser->hash_pw($pass);
    Encode::from_to($hash, "iso-8859-1", "utf8");
    my $user = $rs->create({
        username   => $user,
        email      => $email,
        password   => $hash,
        first_name => $first_name,
        last_name  => $last_name,
        parent_id  => $parent_id,
    });

    $user->update() or die "Failed to save new user\n";

    print "User created\n";
}
else {
    my $user = $rs->find({username => $user});

    $user or die "Cannot find user '$user' in database!\n";

    $user->email($email)                   if $email;
    $user->first_name($first_name)         if $first_name;
    $user->last_name($last_name)           if $last_name;
    $user->password($user->hash_pw($pass)) if $pass;

    $user->update() or die "Failed to update user\n";

    print "User updated\n";
}

exit(0);
