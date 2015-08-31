use utf8;
package TankTracker::Schema::WaterTestCsv;

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
__PACKAGE__->table("public.water_test_csv");
__PACKAGE__->add_columns(
  "tank_id",
  { data_type => "integer", is_nullable => 1 },
  "tank_name",
  { data_type => "text", is_nullable => 1 },
  "water_type",
  {
    data_type => "enum",
    extra => { custom_type_name => "water_type", list => ["salt", "fresh"] },
    is_nullable => 1,
  },
  "owner_id",
  { data_type => "integer", is_nullable => 1 },
  "owner_first_name",
  { data_type => "text", is_nullable => 1 },
  "owner_last_name",
  { data_type => "text", is_nullable => 1 },
  "test_id",
  { data_type => "integer", is_nullable => 1 },
  "test_date",
  { data_type => "timestamp", is_nullable => 1 },
  "user_id",
  { data_type => "integer", is_nullable => 1 },
  "tester_first_name",
  { data_type => "text", is_nullable => 1 },
  "tester_last_name",
  { data_type => "text", is_nullable => 1 },
  "salinity",
  { data_type => "numeric", is_nullable => 1 },
  "ph",
  { data_type => "numeric", is_nullable => 1 },
  "ammonia",
  { data_type => "numeric", is_nullable => 1 },
  "nitrite",
  { data_type => "numeric", is_nullable => 1 },
  "nitrate",
  { data_type => "numeric", is_nullable => 1 },
  "calcium",
  { data_type => "numeric", is_nullable => 1 },
  "phosphate",
  { data_type => "numeric", is_nullable => 1 },
  "magnesium",
  { data_type => "numeric", is_nullable => 1 },
  "kh",
  { data_type => "numeric", is_nullable => 1 },
  "gh",
  { data_type => "numeric", is_nullable => 1 },
  "copper",
  { data_type => "numeric", is_nullable => 1 },
  "iodine",
  { data_type => "numeric", is_nullable => 1 },
  "strontium",
  { data_type => "numeric", is_nullable => 1 },
  "temperature",
  { data_type => "numeric", is_nullable => 1 },
  "water_change",
  { data_type => "numeric", is_nullable => 1 },
  "tds",
  { data_type => "numeric", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-31 11:26:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5xLObhbRzlpogR1AWkiXIw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
