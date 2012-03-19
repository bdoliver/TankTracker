use utf8;
package TankTracker::Schema::Result::TrackerUserRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::TrackerUserRole

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

=head1 TABLE: C<tracker_user_role>

=cut

__PACKAGE__->table("tracker_user_role");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "role_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=item * L</role_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id", "role_id");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<TankTracker::Schema::Result::TrackerRole>

=cut

__PACKAGE__->belongs_to(
  "role",
  "TankTracker::Schema::Result::TrackerRole",
  { role_id => "role_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<TankTracker::Schema::Result::TrackerUser>

=cut

__PACKAGE__->belongs_to(
  "user",
  "TankTracker::Schema::Result::TrackerUser",
  { user_id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-03-13 09:43:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7J+ol31nLJJzB+TOC6IS7w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
