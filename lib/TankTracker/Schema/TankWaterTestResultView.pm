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
  "test_result",
  { data_type => "numeric", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-11 11:31:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OYG/yLBJDZGjeWu+h0tGvw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
