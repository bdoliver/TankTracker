use utf8;
package TankTracker::Schema::Result::InventoryType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::InventoryType

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

=head1 TABLE: C<inventory_type>

=cut

__PACKAGE__->table("inventory_type");

=head1 ACCESSORS

=head2 type_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 class_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 type

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "type_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "class_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "type",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</type_id>

=back

=cut

__PACKAGE__->set_primary_key("type_id");

=head1 RELATIONS

=head2 class

Type: belongs_to

Related object: L<TankTracker::Schema::Result::InventoryClass>

=cut

__PACKAGE__->belongs_to(
  "class",
  "TankTracker::Schema::Result::InventoryClass",
  { class_id => "class_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 inventories

Type: has_many

Related object: L<TankTracker::Schema::Result::Inventory>

=cut

__PACKAGE__->has_many(
  "inventories",
  "TankTracker::Schema::Result::Inventory",
  { "foreign.type_id" => "self.type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-24 15:05:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fdXkiRwl09b88axnIrZqMw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
