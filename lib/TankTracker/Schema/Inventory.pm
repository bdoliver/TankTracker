use utf8;
package TankTracker::Schema::Inventory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.inventory");
__PACKAGE__->add_columns(
  "inventory_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "inventory_inventory_id_seq",
  },
  "inventory_type",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "inventory_type",
      list => ["consumable", "equipment", "fish", "invertebrate", "coral"],
    },
    is_nullable => 0,
  },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 0 },
  "purchase_date",
  { data_type => "date", is_nullable => 0 },
  "purchase_price",
  { data_type => "money", is_nullable => 0 },
  "external_ref",
  { data_type => "text", is_nullable => 1 },
  "photo_filename",
  { data_type => "text", is_nullable => 1 },
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
__PACKAGE__->set_primary_key("inventory_id");
__PACKAGE__->has_many(
  "tank_inventories",
  "TankTracker::Schema::TankInventory",
  { "foreign.inventory_id" => "self.inventory_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "tracker_user",
  "TankTracker::Schema::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-25 14:49:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:q1Er/Bj/AikaiKfVBcjuvg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
