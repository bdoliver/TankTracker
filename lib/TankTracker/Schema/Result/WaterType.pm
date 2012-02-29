use utf8;
package TankTracker::Schema::Result::WaterType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::WaterType

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

=head1 TABLE: C<water_type>

=cut

__PACKAGE__->table("water_type");

=head1 ACCESSORS

=head2 water_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'water_type_water_id_seq'

=head2 water_type

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "water_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "water_type_water_id_seq",
  },
  "water_type",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</water_id>

=back

=cut

__PACKAGE__->set_primary_key("water_id");

=head1 RELATIONS

=head2 tanks

Type: has_many

Related object: L<TankTracker::Schema::Result::Tank>

=cut

__PACKAGE__->has_many(
  "tanks",
  "TankTracker::Schema::Result::Tank",
  { "foreign.water_id" => "self.water_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-02-28 08:13:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cJ4mVCVsfusWXyTauh63Yg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
