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
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "test_date",
  {
    data_type     => "timestamp",
    default_value => \"('now'::text)::date",
    is_nullable   => 0,
  },
);
__PACKAGE__->set_primary_key("test_id");
__PACKAGE__->might_have(
  "diary",
  "TankTracker::Schema::Diary",
  { "foreign.test_id" => "self.test_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "tracker_user",
  "TankTracker::Schema::TrackerUser",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "water_test_results",
  "TankTracker::Schema::WaterTestResult",
  { "foreign.test_id" => "self.test_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-11 11:31:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/3kDYe29xvt4FAGZ0osrHg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
