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
  sequence: 'tracker_user_user_id_seq'

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

=cut

__PACKAGE__->add_columns(
  "user_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "tracker_user_user_id_seq",
  },
  "login",
  { data_type => "text", is_nullable => 0 },
  "user_name",
  { data_type => "text", is_nullable => 1 },
  "email_address",
  { data_type => "text", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 RELATIONS

=head2 sessions

Type: has_many

Related object: L<TankTracker::Schema::Result::Session>

=cut

__PACKAGE__->has_many(
  "sessions",
  "TankTracker::Schema::Result::Session",
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


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-03-13 10:14:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NGq2sinInTQ4LkF81h3EcQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
use Crypt::Eksblowfish::Bcrypt qw(bcrypt_hash);

sub hash_pw {
	my ( $self, $pw ) = @_;

	return $pw 
		? bcrypt_hash({ key_nul => 1,
				cost    => 8,
				salt    => ']+_%%^981#^!*|vB' }, $pw)
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
