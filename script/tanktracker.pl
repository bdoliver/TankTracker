# __PACKAGE__->config(
#     schema_class => 'TankTracker::Schema',
#
#     connect_info => {
#         dsn => 'dbi:Pg:dbname=TankTracker',
#         user => '',
#         password => '',
#     }
# );
{
    'TankTracker::Model::DB' => {
        connect_info => {
             dsn => 'dbi:Pg:dbname=TankTracker',
             user => '',
             password => '',
        },
    },
}
