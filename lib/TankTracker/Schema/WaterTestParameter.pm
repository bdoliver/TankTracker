use utf8;
package TankTracker::Schema::WaterTestParameter;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.water_test_parameter");
__PACKAGE__->add_columns(
  "parameter_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "water_test_parameter_parameter_id_seq",
  },
  "parameter",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "parameter_type",
      list => [
        "salinity",
        "ph",
        "ammonia",
        "nitrite",
        "nitrate",
        "calcium",
        "phosphate",
        "magnesium",
        "kh",
        "gh",
        "copper",
        "iodine",
        "strontium",
        "temperature",
        "water_change",
        "tds",
      ],
    },
    is_nullable => 0,
  },
  "salt_water",
  { data_type => "boolean", is_nullable => 0 },
  "fresh_water",
  { data_type => "boolean", is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 0 },
  "label",
  { data_type => "text", is_nullable => 0 },
  "rgb_colour",
  { data_type => "char", is_nullable => 0, size => 7 },
);
__PACKAGE__->set_primary_key("parameter_id");
__PACKAGE__->add_unique_constraint("water_test_parameter_parameter_key", ["parameter"]);
__PACKAGE__->has_many(
  "tank_water_test_parameters",
  "TankTracker::Schema::TankWaterTestParameter",
  { "foreign.parameter_id" => "self.parameter_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-11 11:44:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nZKV/0G4RddLJGDlEumKyg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
