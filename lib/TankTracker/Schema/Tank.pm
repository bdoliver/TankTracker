use utf8;
package TankTracker::Schema::Tank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.tank");
__PACKAGE__->add_columns(
  "tank_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "tank_tank_id_seq",
  },
  "owner_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "water_type",
  {
    data_type => "enum",
    extra => { custom_type_name => "water_type", list => ["salt", "fresh"] },
    is_nullable => 0,
  },
  "tank_name",
  { data_type => "text", is_nullable => 0 },
  "notes",
  { data_type => "text", is_nullable => 1 },
  "capacity",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "length",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "width",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "depth",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 1 },
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
__PACKAGE__->set_primary_key("tank_id");
__PACKAGE__->has_many(
  "diaries",
  "TankTracker::Schema::Diary",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "inventories",
  "TankTracker::Schema::Inventory",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "owner",
  "TankTracker::Schema::TrackerUser",
  { user_id => "owner_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "tank_parameters",
  "TankTracker::Schema::TankParameter",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "tank_user_accesses",
  "TankTracker::Schema::TankUserAccess",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "tank_water_test_parameters",
  "TankTracker::Schema::TankWaterTestParameter",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-11 11:31:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:R5d4nDYt2kG9Ka+Nymkm6Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
