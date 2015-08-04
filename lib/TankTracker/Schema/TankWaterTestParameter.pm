use utf8;
package TankTracker::Schema::TankWaterTestParameter;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.tank_water_test_parameter");
__PACKAGE__->add_columns(
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "parameter_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "parameter",
  { data_type => "text", is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 0 },
  "label",
  { data_type => "text", is_nullable => 0 },
  "rgb_colour",
  { data_type => "char", is_nullable => 0, size => 7 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 1 },
  "chart",
  { data_type => "boolean", default_value => \"true", is_nullable => 1 },
  "param_order",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("tank_id", "parameter_id");
__PACKAGE__->belongs_to(
  "parameter",
  "TankTracker::Schema::WaterTestParameter",
  { parameter_id => "parameter_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "tank",
  "TankTracker::Schema::Tank",
  { tank_id => "tank_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "water_test_results",
  "TankTracker::Schema::WaterTestResult",
  {
    "foreign.parameter_id" => "self.parameter_id",
    "foreign.tank_id"      => "self.tank_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-11 15:39:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:V+Q2M65Bek1VxyEAfS9Xjg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
