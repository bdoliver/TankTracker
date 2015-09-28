use utf8;
package TankTracker::Schema::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("public.user");
__PACKAGE__->add_columns(
  "user_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "user_user_id_seq",
  },
  "username",
  { data_type => "text", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "role",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "user_role",
      list => ["admin", "guest", "owner", "user"],
    },
    is_nullable => 0,
  },
  "first_name",
  { data_type => "text", is_nullable => 1 },
  "last_name",
  { data_type => "text", is_nullable => 1 },
  "email",
  { data_type => "text", is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 1 },
  "parent_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "login_attempts",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "last_login",
  { data_type => "timestamp", is_nullable => 1 },
  "created_on",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "updated_on",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
);
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->has_many(
  "diaries",
  "TankTracker::Schema::Diary",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "inventories",
  "TankTracker::Schema::Inventory",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "parent",
  "TankTracker::Schema::User",
  { user_id => "parent_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);
__PACKAGE__->has_many(
  "tank_photos",
  "TankTracker::Schema::TankPhoto",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "tank_user_accesses",
  "TankTracker::Schema::TankUserAccess",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "tanks",
  "TankTracker::Schema::Tank",
  { "foreign.owner_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->might_have(
  "user_preference",
  "TankTracker::Schema::UserPreference",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "users",
  "TankTracker::Schema::User",
  { "foreign.parent_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "water_tests",
  "TankTracker::Schema::WaterTest",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-25 14:49:01
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Dk+GjCNs43JP+kNl1x6jPg

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

use List::Util qw(any);

sub can_add_tank {
    my ( $self ) = @_;

    my $role = $self->role();

    return ($role eq 'admin' or $role eq 'owner') ? 1 : 0;
}

sub can_edit_tank {
    my ( $self, $tank_id ) = @_;

    $tank_id or return 0;

    # admin user can edit everything:
    return 1 if $self->role() eq 'admin';

    my $access = $self->result_source
                      ->schema->resultset('TankUserAccess')
                      ->find({
        'user_id' => $self->user_id(),
        'tank_id' => $tank_id,
    });

    return 0 if not $access;

    my $access_role = $access->role();

    return $access_role eq 'owner' ? 1 : 0;
}

sub can_access_tank {
    my ( $self, $tank_id ) = @_;

    $tank_id or return 0;

    return any {
        $_->tank_id() eq $tank_id
    } $self->tank_user_accesses->all();
}

sub can_admin_tank {
    my ( $self, $tank_id ) = @_;

    $tank_id or return 0;

    return any {
        ( $_->tank_id() eq $tank_id ) and $_->admin()
    } $self->tank_user_accesses->all();
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
