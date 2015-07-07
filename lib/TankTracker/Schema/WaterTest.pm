use utf8;
package TankTracker::Schema::WaterTest;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.water_test");
__PACKAGE__->add_columns(
  "test_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "water_test_test_id_seq",
  },
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "test_date",
  {
    data_type     => "timestamp",
    default_value => \"('now'::text)::date",
    is_nullable   => 1,
  },
  "result_salinity",
  { data_type => "numeric", is_nullable => 1 },
  "result_ph",
  { data_type => "numeric", is_nullable => 1 },
  "result_ammonia",
  { data_type => "numeric", is_nullable => 1 },
  "result_nitrite",
  { data_type => "numeric", is_nullable => 1 },
  "result_nitrate",
  { data_type => "numeric", is_nullable => 1 },
  "result_calcium",
  { data_type => "numeric", is_nullable => 1 },
  "result_phosphate",
  { data_type => "numeric", is_nullable => 1 },
  "result_magnesium",
  { data_type => "numeric", is_nullable => 1 },
  "result_kh",
  { data_type => "numeric", is_nullable => 1 },
  "result_alkalinity",
  { data_type => "numeric", is_nullable => 1 },
  "temperature",
  { data_type => "numeric", is_nullable => 1 },
  "water_change",
  { data_type => "numeric", is_nullable => 1 },
  "notes",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("test_id");
__PACKAGE__->has_many(
  "diaries",
  "TankTracker::Schema::Diary",
  { "foreign.test_id" => "self.test_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "tank",
  "TankTracker::Schema::Tank",
  { tank_id => "tank_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "user",
  "TankTracker::Schema::TrackerUser",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-28 10:54:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JRFXZB0RC17rnpz52hj5lQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
