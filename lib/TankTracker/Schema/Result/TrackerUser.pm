use utf8;
package TankTracker::Schema::Result::TrackerUser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TankTracker::Schema::Result::TrackerUser

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

=head1 TABLE: C<tracker_user>

=cut

__PACKAGE__->table("tracker_user");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 login

  data_type: 'text'
  is_nullable: 0

=head2 user_name

  data_type: 'text'
  is_nullable: 1

=head2 email_address

  data_type: 'text'
  is_nullable: 0

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "login",
  { data_type => "text", is_nullable => 0 },
  "user_name",
  { data_type => "text", is_nullable => 1 },
  "email_address",
  { data_type => "text", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<email_address_unique>

=over 4

=item * L</email_address>

=back

=cut

__PACKAGE__->add_unique_constraint("email_address_unique", ["email_address"]);

=head1 RELATIONS

=head2 inventories

Type: has_many

Related object: L<TankTracker::Schema::Result::Inventory>

=cut

__PACKAGE__->has_many(
  "inventories",
  "TankTracker::Schema::Result::Inventory",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tank_diaries

Type: has_many

Related object: L<TankTracker::Schema::Result::TankDiary>

=cut

__PACKAGE__->has_many(
  "tank_diaries",
  "TankTracker::Schema::Result::TankDiary",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tank_users

Type: has_many

Related object: L<TankTracker::Schema::Result::TankUser>

=cut

__PACKAGE__->has_many(
  "tank_users",
  "TankTracker::Schema::Result::TankUser",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tanks

Type: has_many

Related object: L<TankTracker::Schema::Result::Tank>

=cut

__PACKAGE__->has_many(
  "tanks",
  "TankTracker::Schema::Result::Tank",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tracker_user_roles

Type: has_many

Related object: L<TankTracker::Schema::Result::TrackerUserRole>

=cut

__PACKAGE__->has_many(
  "tracker_user_roles",
  "TankTracker::Schema::Result::TrackerUserRole",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 water_tests

Type: has_many

Related object: L<TankTracker::Schema::Result::WaterTest>

=cut

__PACKAGE__->has_many(
  "water_tests",
  "TankTracker::Schema::Result::WaterTest",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</tracker_user_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "tracker_user_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-05-18 14:05:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:26WZqHCS4PUwPsXJmNBpEQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
use Crypt::Eksblowfish::Bcrypt qw(bcrypt_hash en_base64);

sub hash_pw {
    my ( $self, $pw ) = @_;

    return $pw 
           ? en_base64(bcrypt_hash({ key_nul => 1,
                                     cost    => 8,
                                     salt    => ']+_%%^981#^!*|vB' }, $pw))
           : '';
}

sub check_password {

	my ( $self, $attempt ) = @_;

	my $ret = 0;

	if ( $attempt ) {
		my $hash = $self->hash_pw($attempt);

		$ret = ($hash eq $self->password());
	}

	return $ret;
}

1;
