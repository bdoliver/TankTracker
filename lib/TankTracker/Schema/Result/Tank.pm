use utf8;
package TankTracker::Schema::Result::Tank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::Tank

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

=head1 TABLE: C<tank>

=cut

__PACKAGE__->table("tank");

=head1 ACCESSORS

=head2 tank_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 water_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 tank_name

  data_type: 'text'
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 notes

  data_type: 'text'
  is_nullable: 1

=head2 capacity

  data_type: 'numeric'
  is_nullable: 0

=head2 capacity_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 length

  data_type: 'numeric'
  default_value: 0
  is_nullable: 1

=head2 width

  data_type: 'numeric'
  default_value: 0
  is_nullable: 1

=head2 depth

  data_type: 'numeric'
  default_value: 0
  is_nullable: 1

=head2 dimension_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 updated_on

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "tank_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "water_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "tank_name",
  { data_type => "text", is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "notes",
  { data_type => "text", is_nullable => 1 },
  "capacity",
  { data_type => "numeric", is_nullable => 0 },
  "capacity_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "length",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "width",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "depth",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "dimension_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "updated_on",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</tank_id>

=back

=cut

__PACKAGE__->set_primary_key("tank_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<tank_name_unique>

=over 4

=item * L</tank_name>

=back

=cut

__PACKAGE__->add_unique_constraint("tank_name_unique", ["tank_name"]);

=head1 RELATIONS

=head2 capacity

Type: belongs_to

Related object: L<TankTracker::Schema::Result::Capacity>

=cut

__PACKAGE__->belongs_to(
  "capacity",
  "TankTracker::Schema::Result::Capacity",
  { capacity_id => "capacity_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 dimension

Type: belongs_to

Related object: L<TankTracker::Schema::Result::Dimension>

=cut

__PACKAGE__->belongs_to(
  "dimension",
  "TankTracker::Schema::Result::Dimension",
  { dimension_id => "dimension_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 inventories

Type: has_many

Related object: L<TankTracker::Schema::Result::Inventory>

=cut

__PACKAGE__->has_many(
  "inventories",
  "TankTracker::Schema::Result::Inventory",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tank_diaries

Type: has_many

Related object: L<TankTracker::Schema::Result::TankDiary>

=cut

__PACKAGE__->has_many(
  "tank_diaries",
  "TankTracker::Schema::Result::TankDiary",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tank_users

Type: has_many

Related object: L<TankTracker::Schema::Result::TankUser>

=cut

__PACKAGE__->has_many(
  "tank_users",
  "TankTracker::Schema::Result::TankUser",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<TankTracker::Schema::Result::TrackerUser>

=cut

__PACKAGE__->belongs_to(
  "user",
  "TankTracker::Schema::Result::TrackerUser",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 water

Type: belongs_to

Related object: L<TankTracker::Schema::Result::WaterType>

=cut

__PACKAGE__->belongs_to(
  "water",
  "TankTracker::Schema::Result::WaterType",
  { water_id => "water_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 water_tests

Type: has_many

Related object: L<TankTracker::Schema::Result::WaterTest>

=cut

__PACKAGE__->has_many(
  "water_tests",
  "TankTracker::Schema::Result::WaterTest",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-03 12:30:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SsV8d5Uz0XNx+GwhNq6fGQ

sub is_saltwater {
    my $self = shift;

    return ( $self->water_id() == 1 );
}

sub is_freshwater {
    my $self = shift;

    return ! $self->is_saltwater();
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration

1;
