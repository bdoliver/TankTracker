package TankTracker::Model::DB;

use base qw(Rose::DB);

use strict;

use Config::Simple;
use Data::Dumper;

our %DB_PARAMS = ( driver   => 'pg',
		   host     => 'localhost',
		   port     => 5432,
		   database => 'TankTracker',
		   username => 'brendon',
#                   password => 'pgpw',
                   server_time_zone => 'Australia/Melbourne' );

#my $cfg_file = '/usr/local/etc/census-api.conf';
#my $cfg      = Config::Simple->new(syntax   => 'ini',
#                                   filename => $cfg_file);
#die "missing file ($cfg_file)" if ! $cfg;
#
#my $dsn  = $cfg->param('db.dsn');
#my $user = $cfg->param('db.username');
#my $dom  = $cfg->param('db.domain');
#
#$dsn  or die "[db] 'dsn' parameter not set in census-api.conf!";
#$user or die "[db] 'username' parameter not set in census-api.conf!";
#$dom  or die "[db] 'domain' parameter not set in census-api.conf!";
#
### Don't combine these matches into a single regex. Doing it this 
### way allows the elements to be defined in any order in the DSN.
#my ($db) = ($dsn =~ m|dbname=([a-z0-9._]+)| );
#my ( $host ) = ( $dsn =~ m|host=([-a-z0-9.]+)| );
#my ( $port ) = ( $dsn =~ m|port=(\d+)| );
#
#$db   or die "Failed to parse 'dbname' from dsn: '$dsn'";
#$host or die "Failed to parse 'host' from dsn: '$dsn'";
#
#$DB_PARAMS{username} = $user;
#$DB_PARAMS{host}     = $host;
#$DB_PARAMS{database} = $db;
#$DB_PARAMS{port}     = $port || 5432;
#$DB_PARAMS{domain}   = $dom;

__PACKAGE__->use_private_registry;

TankTracker::Model::DB->register_db(%DB_PARAMS);

1;

