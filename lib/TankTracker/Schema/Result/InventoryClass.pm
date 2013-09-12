use utf8;
package TankTracker::Schema::Result::InventoryClass;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::InventoryClass

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

=head1 TABLE: C<inventory_class>

=cut

__PACKAGE__->table("inventory_class");

=head1 ACCESSORS

=head2 class_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 class

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "class_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "class",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</class_id>

=back

=cut

__PACKAGE__->set_primary_key("class_id");

=head1 RELATIONS

=head2 inventory_types

Type: has_many

Related object: L<TankTracker::Schema::Result::InventoryType>

=cut

__PACKAGE__->has_many(
  "inventory_types",
  "TankTracker::Schema::Result::InventoryType",
  { "foreign.class_id" => "self.class_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-24 15:05:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YP8xD3WaVg1EFHt0XVeLjg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
