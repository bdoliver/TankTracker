use utf8;
package TankTracker::Schema::TankPhoto;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.tank_photos");
__PACKAGE__->add_columns(
  "photo_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "tank_photos_photo_id_seq",
  },
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "file_path",
  { data_type => "text", is_nullable => 0 },
  "caption",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("photo_id");
__PACKAGE__->belongs_to(
  "tank",
  "TankTracker::Schema::Tank",
  { tank_id => "tank_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-09-04 14:12:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sMr/9a1njYUZM1nMAm0Syw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
