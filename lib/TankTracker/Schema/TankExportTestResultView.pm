use utf8;
package TankTracker::Schema::TankExportTestResultView;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");
__PACKAGE__->table("public.tank_export_test_result_view");
__PACKAGE__->add_columns(
  "tank_id",
  { data_type => "integer", is_nullable => 1 },
  "user_id",
  { data_type => "integer", is_nullable => 1 },
  "test_date",
  { data_type => "timestamp", is_nullable => 1 },
  "test_id",
  { data_type => "integer", is_nullable => 1 },
  "test_results",
  { data_type => "numeric[]", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-08-14 10:35:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ltNvtYOzU9LtlLPMdvLOkQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
