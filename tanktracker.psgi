use strict;
use warnings;

use TankTracker;

my $app = TankTracker->apply_default_middlewares(TankTracker->psgi_app);
$app;

