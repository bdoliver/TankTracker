#!/bin/sh

op=''

while [ -n "$1" ]; do
    case "$1" in
              start)  op=$1
                      ;;
 stop|shutdown|kill)  op=$1
                      ;;
             status)  op=$1
                      ;;
         production)  TRACKER_ROOT=/opt
                      env=$1
                      ;;
    esac
    shift
done

if [ -z "$env" ]; then
    TRACKER_ROOT=$HOME/src
    env=development
fi

TRACKER_DIR=$TRACKER_ROOT/TankTracker

pidFile=$TRACKER_DIR/log/starman.pid
logFile=$TRACKER_DIR/log/starman-access.log
errFile=$TRACKER_DIR/log/starman-error.log
srvFile=$TRACKER_DIR/log/starman.log

port=3000

RETVAL=

case "$op" in
     start)
            echo "Starting $env server"

            if [ -f $pidFile ]; then
                echo "PID file '$pidFile' exists! Server may already be running!" >&2
                exit 1
            fi

            cd $TRACKER_DIR &&
                starman --daemonize           \
                        --port $port          \
                        --pid $pidFile        \
                        --error-log $errFile  \
                        --access-log $logFile \
                        ./bin/app.pl >$srvFile 2>&1

            sleep 2 # give server time to start up
            echo "Server started. PID=`cat $pidFile`"
            RETVAL=0
            ;;

stop|shutdown|kill)
            RETVAL=1

            if [ "$op" == "kill" ]; then
                echo "Emergency server shutdown."
                termSig=INT
            else
                echo "Graceful server shutdown."
                termSig=QUIT
            fi

            if [ -f "$pidFile" ]; then
                pid=`cat $pidFile`

                if [ -n "$pid" ]; then
                        if kill -$termSig $pid; then
                            rm -f "$pidFile"
                        fi
                        RETVAL=0
                else 
                        echo "No PID found in $pidFile" >&2
                fi
            else 
                echo "PID file '$pidFile' not found - server may not be running!" >&2
            fi
            ;;

    status)
            RETVAL=1

            if [ -f $pidFile ]; then
                echo "Server PID file: $pidFile"
                pid=`cat $pidFile`

                if [ -n "$pid" ]; then
                    process=`ps -p $pid|grep -v PID|awk '{print $4$5}'`
                    if [ -n "$process" -a "$process" == "starmanmaster" ]; then
                        echo "Starman master process running at PID=$pid";
                        RETVAL=0
                    else
                        echo "Unexpected process '$process' running at PID=$pid"
                    fi
                else
                    echo "Starman master process is not running (no PID found)"
                fi
            else 
                echo "Server is not running (no PID file)"
            fi
            ;;

        *)  echo "Usage: $0 [start|stop|kill|status|] [env]" >&2
            RETVAL=1
esac

exit $RETVAL
