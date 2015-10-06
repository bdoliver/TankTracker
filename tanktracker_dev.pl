# Dev configuration:
{
    'name ' => 'TankTracker',

    'Model::TankTracker' => {
        'schema_class' => 'TankTracker::Schema',
        'connect_info' => {
             'dsn'      => 'dbi:Pg:',
             'user'     => '',
             'password' => '',
        },
    },
}
