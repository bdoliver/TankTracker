use utf8;
package TankTracker::Schema::Result::Dimension;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::Dimension

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

=head1 TABLE: C<dimension>

=cut

__PACKAGE__->table("dimension");

=head1 ACCESSORS

=head2 dimension_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 dimension_desc

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "dimension_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "dimension_desc",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</dimension_id>

=back

=cut

__PACKAGE__->set_primary_key("dimension_id");

=head1 RELATIONS

=head2 tanks

Type: has_many

Related object: L<TankTracker::Schema::Result::Tank>

=cut

__PACKAGE__->has_many(
  "tanks",
  "TankTracker::Schema::Result::Tank",
  { "foreign.dimension_id" => "self.dimension_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-03 12:30:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yMbEKiRrRMPRHAQrnrzVEQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
