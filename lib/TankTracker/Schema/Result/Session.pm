use utf8;
package TankTracker::Schema::Result::Session;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::Session

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<sessions>

=cut

__PACKAGE__->table("sessions");

=head1 ACCESSORS

=head2 session_id

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 session_ts

  data_type: 'datetime'
  default_value: current_timestamp
  is_nullable: 1

=head2 session

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "session_id",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "session_ts",
  {
    data_type     => "datetime",
    default_value => \"current_timestamp",
    is_nullable   => 1,
  },
  "session",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</session_id>

=back

=cut

__PACKAGE__->set_primary_key("session_id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-03 12:30:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wXfwBt3o9Y5D8C94EQuq2A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
