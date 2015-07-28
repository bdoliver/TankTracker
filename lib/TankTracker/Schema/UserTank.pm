use utf8;
package TankTracker::Schema::UserTank;

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
__PACKAGE__->table("public.user_tanks");
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
  "active",
  { data_type => "boolean", is_nullable => 1 },
  "admin",
  { data_type => "boolean", is_nullable => 1 },
  "owner_id",
  { data_type => "integer", is_nullable => 1 },
  "user_id",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-07-28 09:49:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:glXhwQqncvBhEkuM97iehg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
