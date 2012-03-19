#!/bin/sh

op=''

while [ -n "$1" ]; do
    case "$1" in
        start)  op=$1
                ;;
        stop)   op=$1
                ;;
        status) op=$1
                ;;
    production) TRACKER_DIR=/opt
                env=$1
                ;;
    esac
    shift
done

if [ -z "$env" ]; then
        TRACKER_DIR=$HOME/DEVEL
        env=development
fi

pidFile=$TRACKER_DIR/TankTracker/logs/starman.pid
logFile=$TRACKER_DIR/TankTracker/logs/starman.log

case "$op" in
        start)
                echo "Starting $env server"

                if [ -f $pidFile ]; then
                   echo "PID file '$pidFile' exists! Server may already be running!" >&2
                   exit 1
                fi

                if [ -f $logFile ]; then
                        mv $logFile $logFile.prev
                fi

                cd $TRACKER_DIR/TankTracker &&
                        plackup -E $env \
                		-s Starman \
                		-a $TRACKER_DIR/TankTracker/bin/app.pl \
                                -D --pid $pidFile --error-log $logFile \
                		-p 5000 >$logFile 2>&1

                echo "Server started. PID=`cat $pidFile`"
                ;;

        stop)
                echo "Stopping server"

                if [ -f $pidFile ]; then
                        pid=`cat $pidFile`

                        if [ -n "$pid" ]; then
                                kill -TERM $pid
                        else 
                                echo "No PID found in $pidFile" >&2
                        fi
                else 
                        echo "PID file '$pidFile' not found - server may not be running!" >&2
                fi
                ;;

        status)
                if [ -f $pidFile ]; then
                        echo "Server PID file: $pidFile"

                        pid=`cat $pidFile`

echo "looking for pid=$pid"
                fi
                        
                ;;

        *)      echo "Usage: $0 [start|stop] [env]" >&2
esac
