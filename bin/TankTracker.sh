#!/bin/sh

case "$1" in
    production) TRACKER_DIR=/opt
                env=$1
                ;;
             *) TRACKER_DIR=$HOME/DEVEL
                env=development
                ;;
esac

pidFile=$TRACKER_DIR/TankTracker/logs/starman.pid
logFile=$TRACKER_DIR/TankTracker/logs/starman.log

cd $TRACKER_DIR/TankTracker &&
        plackup 	-E $env \
			-s Starman \
			-a $TRACKER_DIR/TankTracker/bin/app.pl \
                        -D --pid $pidFile --error-log $logFile \
			-p 5000 >$logFile 2>&1
                

echo "Server PID=`cat $pidFile`"
