#!/usr/bin/env perl

use strict;
use warnings;

use Dancer ':script';
use Encode;
use FindBin qw($Bin);

use lib "$Bin/../lib";

use TankTracker::Schema;

use Getopt::Long qw(:config no_ignore_case bundling);

## Configure database connection from Dancer's config.yml - SWEET!!
our $dbi_dsn    = config->{plugins}->{DBIC}->{default}->{dsn};
our $dbi_user   = config->{plugins}->{DBIC}->{default}->{user};
our $dbi_pass   = config->{plugins}->{DBIC}->{default}->{pass};
our $dbi_params = config->{plugins}->{DBIC}->{default}->{options};

our ( $add, $edit, $login, $pass, $email, $name );

Getopt::Long::GetOptions('login=s' => \$login,
			 'pass=s'  => \$pass,
			 'email=s' => \$email,
			 'name=s'  => \$name,
			 'add'     => \$add);

$login or die "Missing --login=login_name (mandatory)\n";

if ( $add ) {
    $email or die "--email 'email\@example.com' mandatory for new a/c\n";
    $pass  or die "--pass XXXX mandatory for new a/c\n";
}
else {
    ( $email or $pass or $name ) or
            die "Need at least one of --email, --pass or --name when editing a user.\n";
}

my $schema = TankTracker::Schema->connect($dbi_dsn,
                                          $dbi_user,
                                          $dbi_pass,
                                          $dbi_params) or
                die "DBI connect failed!\n";

my $rs = $schema->resultset('TrackerUser');

if ( $add ) {
    ## create user:
    my $user;
    my $hash = TankTracker::Schema::Result::TrackerUser->hash_pw($pass);
    Encode::from_to($hash, "iso-8859-1", "utf8");
    $user = $rs->create({login         => $login,
                         email_address => $email,
                         password      => $hash,
                         user_name     => $name});

    $user->update() or die "Failed to save new user\n";

    print "User created\n";
}
else {
    my $user = $rs->find({login => $login});

    $user or die "Cannot find user '$login' in database!\n";

    $user->email_address($email)           if $email;
    $user->user_name($name)                if $name;
    $user->password($user->hash_pw($pass)) if $pass;

    $user->update() or die "Failed to update user\n";

    print "User updated\n";
}

exit(0);
