use utf8;
package TankTracker::Schema::UserPreference;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.user_preferences");
__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "recs_per_page",
  { data_type => "integer", default_value => 10, is_nullable => 0 },
  "tank_order_col",
  {
    data_type => "enum",
    default_value => "tank_id",
    extra => {
      custom_type_name => "tank_order_type",
      list => ["tank_id", "tank_name", "created_on", "updated_on"],
    },
    is_nullable => 0,
  },
  "tank_order_seq",
  { data_type => "text", default_value => "asc", is_nullable => 0 },
  "water_test_order_col",
  {
    data_type => "enum",
    default_value => "test_id",
    extra => {
      custom_type_name => "water_test_order_type",
      list => ["test_id", "test_date"],
    },
    is_nullable => 0,
  },
  "water_test_order_seq",
  { data_type => "text", default_value => "desc", is_nullable => 0 },
  "updated_on",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
);
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->belongs_to(
  "tracker_user",
  "TankTracker::Schema::TrackerUser",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-09-01 15:01:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KvN/uOdoA43EwZbdZlaGyw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
