use utf8;
package TankTracker::Schema::Result::Inventory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::Inventory

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

=head1 TABLE: C<inventory>

=cut

__PACKAGE__->table("inventory");

=head1 ACCESSORS

=head2 item_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 tank_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 0

=head2 purchase_date

  data_type: 'date'
  is_nullable: 0

=head2 purchase_price

  data_type: 'money'
  is_nullable: 0

=head2 quantity

  data_type: 'number'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "item_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 0 },
  "purchase_date",
  { data_type => "date", is_nullable => 0 },
  "purchase_price",
  { data_type => "money", is_nullable => 0 },
  "quantity",
  { data_type => "number", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</item_id>

=back

=cut

__PACKAGE__->set_primary_key("item_id");

=head1 RELATIONS

=head2 tank

Type: belongs_to

Related object: L<TankTracker::Schema::Result::Tank>

=cut

__PACKAGE__->belongs_to(
  "tank",
  "TankTracker::Schema::Result::Tank",
  { tank_id => "tank_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 type

Type: belongs_to

Related object: L<TankTracker::Schema::Result::InventoryType>

=cut

__PACKAGE__->belongs_to(
  "type",
  "TankTracker::Schema::Result::InventoryType",
  { type_id => "type_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
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


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-24 11:31:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:77/9xPRCTjn7eZEmIAMXtg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
