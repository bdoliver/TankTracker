use utf8;
package TankTracker::Schema::TankUserAccess;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.tank_user_access");
__PACKAGE__->add_columns(
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "role",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "user_role",
      list => ["admin", "guest", "owner", "user"],
    },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("tank_id", "user_id");
__PACKAGE__->belongs_to(
  "tank",
  "TankTracker::Schema::Tank",
  { tank_id => "tank_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "tank_photos",
  "TankTracker::Schema::TankPhoto",
  {
    "foreign.tank_id" => "self.tank_id",
    "foreign.user_id" => "self.user_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "tracker_user",
  "TankTracker::Schema::User",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-28 12:01:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gcv9Xa/FAvH7e8JGnho2xg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
