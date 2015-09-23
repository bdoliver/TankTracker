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
  "capacity_units",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "capacity_unit",
      list => ["litres", "gallons", "us gallons"],
    },
    is_nullable => 0,
  },
  "capacity",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "dimension_units",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "dimension_unit",
      list => ["mm", "cm", "m", "inches", "feet"],
    },
    is_nullable => 0,
  },
  "length",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "width",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "depth",
  { data_type => "numeric", default_value => 0, is_nullable => 1 },
  "temperature_scale",
  {
    data_type => "enum",
    extra => { custom_type_name => "temperature_scale", list => ["C", "F"] },
    is_nullable => 0,
  },
  "test_reminder",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "last_reminder",
  { data_type => "date", is_nullable => 1 },
  "reminder_freq",
  {
    data_type => "enum",
    default_value => "daily",
    extra => {
      custom_type_name => "frequency",
      list => ["daily", "weekly", "monthly"],
    },
    is_nullable => 1,
  },
  "reminder_time",
  { data_type => "time", default_value => "09:00:00", is_nullable => 1 },
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
__PACKAGE__->belongs_to(
  "owner",
  "TankTracker::Schema::TrackerUser",
  { user_id => "owner_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "tank_inventories",
  "TankTracker::Schema::TankInventory",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "tank_photos",
  "TankTracker::Schema::TankPhoto",
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


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-09-23 15:01:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZM1Sb1L8nI00vB1SbYKbKA

# Tank may have water tests, create a relationship to the 'last test' view:
__PACKAGE__->might_have(
  "last_water_test",
  "TankTracker::Schema::LastWaterTest",
  { "foreign.tank_id" => "self.tank_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
