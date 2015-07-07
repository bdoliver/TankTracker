# rename this file to tanktracker.yml and put a ':' after 'name' if
# you want to use YAML like in old versions of Catalyst
#name TankTracker
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
    'name ' => 'TankTracker',

    'Model::TankTracker' => {
        'schema_class' => 'TankTracker::Schema',
        'connect_info' => {
             'dsn'      => 'dbi:Pg:dbname=TankTracker',
             'user'     => '',
             'password' => '',
        },
    },
}
