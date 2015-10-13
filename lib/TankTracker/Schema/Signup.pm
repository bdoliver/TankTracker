use utf8;
package TankTracker::Schema::Signup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.signup");
__PACKAGE__->add_columns(
  "signup_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "signup_signup_id_seq",
  },
  "email",
  { data_type => "text", is_nullable => 0 },
  "signup_hash",
  { data_type => "text", is_nullable => 0 },
  "created_on",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
);
__PACKAGE__->set_primary_key("signup_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-13 15:57:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:x0VKvs2QkTstRlqr98Xo3Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
