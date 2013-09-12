use utf8;
package TankTracker::Schema::Result::WaterTest;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::WaterTest

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<water_tests>

=cut

__PACKAGE__->table("water_tests");

=head1 ACCESSORS

=head2 test_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 tank_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 test_date

  data_type: 'date'
  default_value: current_timestamp
  is_nullable: 1

=head2 result_salinity

  data_type: 'numeric'
  is_nullable: 1

=head2 result_ph

  data_type: 'numeric'
  is_nullable: 1

=head2 result_ammonia

  data_type: 'numeric'
  is_nullable: 1

=head2 result_nitrite

  data_type: 'numeric'
  is_nullable: 1

=head2 result_nitrate

  data_type: 'numeric'
  is_nullable: 1

=head2 result_calcium

  data_type: 'numeric'
  is_nullable: 1

=head2 result_phosphate

  data_type: 'numeric'
  is_nullable: 1

=head2 result_magnesium

  data_type: 'numeric'
  is_nullable: 1

=head2 result_kh

  data_type: 'numeric'
  is_nullable: 1

=head2 result_alkalinity

  data_type: 'numeric'
  is_nullable: 1

=head2 water_change

  data_type: 'numeric'
  is_nullable: 1

=head2 notes

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "test_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "test_date",
  {
    data_type     => "date",
    default_value => \"current_timestamp",
    is_nullable   => 1,
  },
  "result_salinity",
  { data_type => "numeric", is_nullable => 1 },
  "result_ph",
  { data_type => "numeric", is_nullable => 1 },
  "result_ammonia",
  { data_type => "numeric", is_nullable => 1 },
  "result_nitrite",
  { data_type => "numeric", is_nullable => 1 },
  "result_nitrate",
  { data_type => "numeric", is_nullable => 1 },
  "result_calcium",
  { data_type => "numeric", is_nullable => 1 },
  "result_phosphate",
  { data_type => "numeric", is_nullable => 1 },
  "result_magnesium",
  { data_type => "numeric", is_nullable => 1 },
  "result_kh",
  { data_type => "numeric", is_nullable => 1 },
  "result_alkalinity",
  { data_type => "numeric", is_nullable => 1 },
  "water_change",
  { data_type => "numeric", is_nullable => 1 },
  "notes",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</test_id>

=back

=cut

__PACKAGE__->set_primary_key("test_id");

=head1 RELATIONS

=head2 tank

Type: belongs_to

Related object: L<TankTracker::Schema::Result::Tank>

=cut

__PACKAGE__->belongs_to(
  "tank",
  "TankTracker::Schema::Result::Tank",
  { tank_id => "tank_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 tank_diary

Type: might_have

Related object: L<TankTracker::Schema::Result::TankDiary>

=cut

__PACKAGE__->might_have(
  "tank_diary",
  "TankTracker::Schema::Result::TankDiary",
  { "foreign.test_id" => "self.test_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<TankTracker::Schema::Result::TrackerUser>

=cut

__PACKAGE__->belongs_to(
  "user",
  "TankTracker::Schema::Result::TrackerUser",
  { user_id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-05-19 07:56:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vogce7ZjEksHIETty+5rxw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
