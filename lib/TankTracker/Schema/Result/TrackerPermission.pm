use utf8;
package TankTracker::Schema::Result::TrackerPermission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::TrackerPermission

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

=head1 TABLE: C<tracker_permission>

=cut

__PACKAGE__->table("tracker_permission");

=head1 ACCESSORS

=head2 permission_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'tracker_permission_permission_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "permission_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "tracker_permission_permission_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</permission_id>

=back

=cut

__PACKAGE__->set_primary_key("permission_id");

=head1 RELATIONS

=head2 tracker_role_permissions

Type: has_many

Related object: L<TankTracker::Schema::Result::TrackerRolePermission>

=cut

__PACKAGE__->has_many(
  "tracker_role_permissions",
  "TankTracker::Schema::Result::TrackerRolePermission",
  { "foreign.permission_id" => "self.permission_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</tracker_role_permissions> -> role

=cut

__PACKAGE__->many_to_many("roles", "tracker_role_permissions", "role");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-10-15 13:44:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YHfzid/SMQe+rkAE5L/Q2A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
