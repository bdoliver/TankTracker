use utf8;
package TankTracker::Schema::TankPreference;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.tank_preferences");
__PACKAGE__->add_columns(
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "capacity_units",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "capacity_unit",
      list => ["litres", "gallons", "us gallons"],
    },
    is_nullable => 0,
  },
  "dimension_units",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "dimension_unit",
      list => ["mm", "cm", "m", "inches", "feet"],
    },
    is_nullable => 0,
  },
  "temperature_scale",
  {
    data_type => "enum",
    extra => { custom_type_name => "temperature_scale", list => ["C", "F"] },
    is_nullable => 0,
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
__PACKAGE__->belongs_to(
  "tank",
  "TankTracker::Schema::Tank",
  { tank_id => "tank_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-11 11:58:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:P2hrOVgkyqUj0YzFpEzYkw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
