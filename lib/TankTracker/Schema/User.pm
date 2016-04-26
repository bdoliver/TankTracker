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
__PACKAGE__->table("public.users");
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
  { data_type => "integer", is_nullable => 1 },
  "login_attempts",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "reset_code",
  { data_type => "text", is_nullable => 1 },
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
  "last_pwchange",
  { data_type => "timestamp", is_nullable => 1 },
  "reset_expires",
  { data_type => "timestamp", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->add_unique_constraint("reset_code_idx", ["reset_code"]);
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
  "water_tests",
  "TankTracker::Schema::WaterTest",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-04-04 15:59:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:h84CQcIXIjAiqY5H+q2z+A

use Crypt::SaltedHash;

sub hash_str {
    my ( $self, $pw ) = @_;

    my $crypt_pass = q{};

    if ( $pw ) {
        my $csh = Crypt::SaltedHash->new(algorithm => 'SHA-512');

        $csh->add($pw);

        $crypt_pass = $csh->generate();
    }

    return $crypt_pass;
}

sub check_password {
    my ( $self, $attempt ) = @_;

    return $attempt
            ? Crypt::SaltedHash->validate($self->password(), $attempt)
            : 0;
}

## This when called by Dancer2 app:
sub match_password {
    my ( $self, @args ) = @_;

    return $self->check_password(@args);
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
