use utf8;
package TankTracker::Schema::Result::TankDiary;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::TankDiary

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

=head1 TABLE: C<tank_diary>

=cut

__PACKAGE__->table("tank_diary");

=head1 ACCESSORS

=head2 diary_id

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

=head2 diary_date

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=head2 diary_note

  data_type: 'text'
  is_nullable: 0

=head2 updated_on

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=head2 test_id

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "diary_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "tank_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "diary_date",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "diary_note",
  { data_type => "text", is_nullable => 0 },
  "updated_on",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "test_id",
  { data_type => "int", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</diary_id>

=back

=cut

__PACKAGE__->set_primary_key("diary_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<test_id_unique>

=over 4

=item * L</test_id>

=back

=cut

__PACKAGE__->add_unique_constraint("test_id_unique", ["test_id"]);

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

=head2 test

Type: belongs_to

Related object: L<TankTracker::Schema::Result::WaterTest>

=cut

__PACKAGE__->belongs_to(
  "test",
  "TankTracker::Schema::Result::WaterTest",
  { test_id => "test_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
  },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0Lq1ofG7JCpS//6J1di5CQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
