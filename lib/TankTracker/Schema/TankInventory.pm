use utf8;
package TankTracker::Schema::TankInventory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.tank_inventory");
__PACKAGE__->add_columns(
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "inventory_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "created_on",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "updated_on",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
);
__PACKAGE__->set_primary_key("tank_id", "inventory_id");
__PACKAGE__->belongs_to(
  "inventory",
  "TankTracker::Schema::Inventory",
  { inventory_id => "inventory_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "tank",
  "TankTracker::Schema::Tank",
  { tank_id => "tank_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-09-14 13:21:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fVPEGoT9/Qt0hTLxt/JNNQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
