use utf8;
package TankTracker::Schema::TrackerRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.tracker_role");
__PACKAGE__->add_columns(
  "role_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "tracker_role_role_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("role_id");
__PACKAGE__->has_many(
  "tracker_user_roles",
  "TankTracker::Schema::TrackerUserRole",
  { "foreign.role_id" => "self.role_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->many_to_many("tracker_users", "tracker_user_roles", "tracker_user");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-07-29 11:59:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pmYc5kHz7SZr+qmqxVwPMg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
