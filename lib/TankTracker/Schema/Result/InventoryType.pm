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

=head2 inventory_type_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'inventory_type_inventory_type_id_seq'

=head2 description

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "inventory_type_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "inventory_type_inventory_type_id_seq",
  },
  "description",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</inventory_type_id>

=back

=cut

__PACKAGE__->set_primary_key("inventory_type_id");

=head1 RELATIONS

=head2 inventories

Type: has_many

Related object: L<TankTracker::Schema::Result::Inventory>

=cut

__PACKAGE__->has_many(
  "inventories",
  "TankTracker::Schema::Result::Inventory",
  { "foreign.inventory_type_id" => "self.inventory_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-02-28 08:13:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:f8H5Ae9zfYf3i9xJdPR5Ug


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
