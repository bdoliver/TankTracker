#!/bin/sh

case "$1" in
    production) TRACKER_DIR=/opt
                env=$1
                ;;
             *) TRACKER_DIR=$HOME/DEVEL
                env=development
                ;;
esac

cd $TRACKER_DIR/TankTracker &&
        nohup plackup 	-E $env \
			-s Starman \
			-a $TRACKER_DIR/TankTracker/bin/app.pl \
			-p 5000 > ./logs/starman.log 2>&1 &

echo "Server PID=$!"
