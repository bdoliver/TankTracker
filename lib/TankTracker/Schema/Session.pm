use utf8;
package TankTracker::Schema::Session;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.sessions");
__PACKAGE__->add_columns(
  "session_id",
  { data_type => "varchar", is_nullable => 0, size => 72 },
  "session_ts",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
  "expires",
  { data_type => "integer", is_nullable => 1 },
  "session_data",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("session_id");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-06-23 13:59:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TZA+YI6ibP/tcmc2Uo4Fzw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
