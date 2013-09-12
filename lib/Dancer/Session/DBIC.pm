package Dancer::Session::DBIC;

use strict;
use warnings;

use base 'Dancer::Session::Abstract';

use Dancer::Config 'setting';

use Dancer::Plugin::DBIC 'schema';

our $SERIALISERS = { 'dumper' => { to   => *Dancer::to_dumper,
                                   from => *Dancer::from_dumper },
                     'yaml'   => { to   => *Dancer::to_yaml,
                                   from => *Dancer::from_yaml },
                     'xml'    => { to   => *Dancer::to_xml,
                                   from => *Dancer::from_xml },
                     'json'   => { to   => *Dancer::to_json,
                                   from => *Dancer::from_json }
                   };

our $VERSION = '0.01';

our $DB_CFG = { schema     => 'default',
                table      => 'Session',
                id         => 'session_id',
                data       => 'session',
                serialiser => 'dumper',
              };

sub init {
    my $self = shift;

    $self->SUPER::init(@_);

    my $settings = setting('session_options');

    if ( $settings ) {
        map { $DB_CFG->{$_} = $settings->{$_} if $settings->{$_} }
            keys %$settings;
    }

    exists $SERIALISERS->{$DB_CFG->{serialiser}} or
       die "Invalid session serialiser '$DB_CFG->{serialiser}'";

# Can be useful for debugging:
#     for my $key ( keys %$DB_CFG ) {
#         Dancer::Logger::core(
#              __PACKAGE__ . " session_option '$key' : $DB_CFG->{$key}"
#         );
#     }

}

sub register_serialiser {
    my ( $class, $args ) = @_;

    my $name = delete $args->{name};

    $name or die "register_serialiser() parameter 'name' missing or undef!";

    $args->{from} or die "register_serialiser() parameter 'from' missing or undef!";
    $args->{to}   or die "register_serialiser() parameter 'to' missing or undef!";

    ref($args->{from}) eq 'CODE' or
                     die "register_serialiser() parameter 'from' not a coderef!";
    ref($args->{to})   eq 'CODE' or
                     die "register_serialiser() parameter 'to' not a coderef!";

    $SERIALISERS->{$name} = $args;
}

# create a new session and return the newborn object
# representing that session
sub create {
    return __PACKAGE__->new()->flush();
}

# return the session object corresponding to the given id
sub retrieve {
    my ( $class, $id ) = @_;

    my $table      = $DB_CFG->{table};
    my $idCol      = $DB_CFG->{id};
    my $dataCol    = $DB_CFG->{data};
    my $schema     = $DB_CFG->{schema};
    my $serialiser = $DB_CFG->{serialiser};

    my $session = schema($schema)->resultset($table)
                                 ->find({$idCol => $id});

    my $s = $session->$dataCol() if $session;

    return &{ $SERIALISERS->{$serialiser}->{from} }($s) if $s;
}

# trash the session
sub destroy {
    my ($self)  = @_;

    my $table   = $DB_CFG->{table};
    my $idCol   = $DB_CFG->{id};
    my $dataCol = $DB_CFG->{data};
    my $schema  = $DB_CFG->{schema};

    my $session = schema($schema)->resultset($table)
                                 ->find({$idCol => $self->id()});

    $session->delete() if $session;
}

sub flush {
    my $self       = shift;

    my $table      = $DB_CFG->{table};
    my $idCol      = $DB_CFG->{id};
    my $dataCol    = $DB_CFG->{data};
    my $schema     = $DB_CFG->{schema};
    my $serialiser = $DB_CFG->{serialiser};

    ## serialise session with configured serialiser:
    my $s = &{ $SERIALISERS->{$serialiser}->{to} }($self);

    local $Data::Dumper::Indent = 0 if $serialiser eq 'dumper';

    schema($schema)->resultset($table)
                   ->update_or_create({$idCol   => $self->id(),
                                       $dataCol => $s});
    return $self;
}

1;

__END__

=pod

=head1 NAME

Dancer::Session::DBIC - DBIC-based session backend for Dancer

=head1 DESCRIPTION

Since Dancer::Plugin::DBIC allows easy connection of Dancer
applications to database using DBIx::Class, this module provides
a session engine to allow storage of session data in a table in
a DBIC-connected database.

The session can be serialised to the database using any of Dancer's
core serialisers:

=over 4

=item dumper

=item yaml

=item json

=item xml

=back

The default serialiser is C<dumper>.

=head1 CONFIGURATION

The setting B<session> should be set to C<DBIC> in order to use
this session engine in a Dancer application.

If no other configuration settings are present, this session engine
will expect a table as follows for session storage:

=over 4

        CREATE TABLE sessions ( session_id VARCHAR(40)
                                session    TEXT );

=back

This table is expected to be in the 'default' schema as per your DBIC
plugin configuration.

You may override this session engine's default behaviour by setting
C<session_options> in your configuration as follows:

=over

=item schema

Connect to the database using the named schema (this schema must exist
in your C<plugins:> -> C<DBIC:> configuration).

=item table

This should be set to the name of the C<DBIx::Schema::ResultSet>
class which represents your session table.

=item id

The name of the column in your session table where the session ID
value will be stored.

=item data

The name of the column in your session table where the serialised
session data will be stored.

=item serialiser

Nominate the serialiser to use when dumping session data to the database.
Valid options are C<dumper>, C<yaml>, C<json>, C<xml>.  Dancer will
abort with an error at startup if you nominate an invalid serialiser.

B<NOTE:> If you change this value, be sure to delete all existing records
from your session table before restarting the application.  If this is 
not possible, then you will need to write something to convert your existing
session data to the newly-configured serialised format.

=back

=head2 Example configuration

=over 8

session: "DBIC"

session_options:
   schema: "db_session"
   table:  "TcSession"
   id:     "sess_id"
   data:   "sess_data"
   serialiser: "yaml"

=back

The above configuration would tell the session engine to use the
DBIC schema connection named C<db_session>; the table C<tc_session>
which has columns C<sess_id> for session ID, and C<sess_data> for
the serialised session data.  The session will be serialised using
YAML.

=head1 METHODS

This module implements the "public" API as described by
C<Dancer::Session::Abstract>:

=over 4

=item B<retrieve($id)>

Look for a session with the given id, return the session object if found, undef
if not.

=item B<create()>

Create a new session, return the session object.

=item B<flush()>

Write the session object to the storage engine.

=item B<destroy()>

Remove the current session object from the storage engine.

=back

=head1 DEPENDENCY

This module depends on L<Dancer::Plugin::DBIC>.

=head1 AUTHOR

Brendon Oliver (<brendon.oliver@gmail.com>)

=head1 SEE ALSO

See L<Dancer::Session> for details about session usage in route handlers.

See L<Dancer::Plugin::DBIC> for details about configuring your
database connections.

=head1 COPYRIGHT

This module is copyright (c) 2013 Brendon Oliver <brendon.oliver@gmail.com>

=head1 LICENSE

This module is free software and is released under the same terms as Perl
itself.

=cut
