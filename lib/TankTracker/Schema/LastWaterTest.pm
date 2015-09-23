use utf8;
package TankTracker::Schema::LastWaterTest;

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
__PACKAGE__->table("public.last_water_test");
__PACKAGE__->add_columns(
  "tank_id",
  { data_type => "integer", is_nullable => 1 },
  "last_test_date",
  { data_type => "timestamp", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-09-23 15:20:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+Ac9JXWy8h4Do+s62m01zA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
