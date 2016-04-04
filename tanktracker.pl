# Production configuration:
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

    'uploadtmp'          => '/tmp/tt_uploads',
    'photo_root'         => '/static/images/photos',
    'max_login_attempts' => 5,
    'password_expires_days' => -5,
}
