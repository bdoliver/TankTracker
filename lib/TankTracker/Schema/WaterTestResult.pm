use utf8;
package TankTracker::Schema::WaterTestResult;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.water_test_result");
__PACKAGE__->add_columns(
  "test_result_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "water_test_result_test_result_id_seq",
  },
  "test_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "parameter_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "test_result",
  { data_type => "numeric", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("test_result_id");
__PACKAGE__->belongs_to(
  "tank_water_test_parameter",
  "TankTracker::Schema::TankWaterTestParameter",
  { parameter_id => "parameter_id", tank_id => "tank_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->belongs_to(
  "test",
  "TankTracker::Schema::WaterTest",
  { test_id => "test_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-11 11:31:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tfsy0F3co6j78bowSbStmQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
