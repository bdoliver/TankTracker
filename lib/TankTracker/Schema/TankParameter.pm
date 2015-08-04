use utf8;
package TankTracker::Schema::TankParameter;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.tank_parameters");
__PACKAGE__->add_columns(
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "parameter_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
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
);
__PACKAGE__->set_primary_key("tank_id", "parameter_id");
__PACKAGE__->belongs_to(
  "parameter",
  "TankTracker::Schema::Parameter",
  { parameter_id => "parameter_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "tank",
  "TankTracker::Schema::Tank",
  { tank_id => "tank_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-04 11:51:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:h3E8BvWjrMf3hLP7ulLXLA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
