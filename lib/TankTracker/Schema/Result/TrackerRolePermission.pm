use utf8;
package TankTracker::Schema::Result::TrackerRolePermission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::TrackerRolePermission

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

=head1 TABLE: C<tracker_role_permission>

=cut

__PACKAGE__->table("tracker_role_permission");

=head1 ACCESSORS

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 permission_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "permission_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</role_id>

=item * L</permission_id>

=back

=cut

__PACKAGE__->set_primary_key("role_id", "permission_id");

=head1 RELATIONS

=head2 permission

Type: belongs_to

Related object: L<TankTracker::Schema::Result::TrackerPermission>

=cut

__PACKAGE__->belongs_to(
  "permission",
  "TankTracker::Schema::Result::TrackerPermission",
  { permission_id => "permission_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 role

Type: belongs_to

Related object: L<TankTracker::Schema::Result::TrackerRole>

=cut

__PACKAGE__->belongs_to(
  "role",
  "TankTracker::Schema::Result::TrackerRole",
  { role_id => "role_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-10-15 13:44:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s1TXYMbM+w6Qz93v4y4lAA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
