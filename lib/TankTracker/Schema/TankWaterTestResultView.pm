use utf8;
package TankTracker::Schema::TankWaterTestResultView;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");
__PACKAGE__->table("public.tank_water_test_result_view");
__PACKAGE__->add_columns(
  "tank_id",
  { data_type => "integer", is_nullable => 1 },
  "test_id",
  { data_type => "integer", is_nullable => 1 },
  "test_date",
  { data_type => "timestamp", is_nullable => 1 },
  "user_id",
  { data_type => "integer", is_nullable => 1 },
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
    is_nullable => 1,
  },
  "param_order",
  { data_type => "integer", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "label",
  { data_type => "text", is_nullable => 1 },
  "rgb_colour",
  { data_type => "char", is_nullable => 1, size => 7 },
  "active",
  { data_type => "boolean", is_nullable => 1 },
  "chart",
  { data_type => "boolean", is_nullable => 1 },
  "test_result",
  { data_type => "numeric", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-12 10:47:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KtavRvIF0OffZ9Uw+98pCg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
