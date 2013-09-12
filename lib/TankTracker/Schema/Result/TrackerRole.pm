use utf8;
package TankTracker::Schema::Result::TrackerRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::TrackerRole

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

=head1 TABLE: C<tracker_role>

=cut

__PACKAGE__->table("tracker_role");

=head1 ACCESSORS

=head2 role_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "role_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</role_id>

=back

=cut

__PACKAGE__->set_primary_key("role_id");

=head1 RELATIONS

=head2 tracker_user_roles

Type: has_many

Related object: L<TankTracker::Schema::Result::TrackerUserRole>

=cut

__PACKAGE__->has_many(
  "tracker_user_roles",
  "TankTracker::Schema::Result::TrackerUserRole",
  { "foreign.role_id" => "self.role_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users

Type: many_to_many

Composing rels: L</tracker_user_roles> -> user

=cut

__PACKAGE__->many_to_many("users", "tracker_user_roles", "user");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-03 12:30:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ekvO5Iz6RUKc+k53Kzb/Ew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
