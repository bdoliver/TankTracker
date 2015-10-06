#!/bin/bash


case "$1" in
    dev) export PGDATABASE=TankTracker_dev
         export CATALYST_CONFIG_LOCAL_SUFFIX=dev
         shift
         ;;
      *) export PGDATABASE=TankTracker
         ;;
esac

export CATALYST_CONFIG_LOCAL_SUFFIX=${CATALYST_CONFIG_LOCAL_SUFFIX:-local}
export CATALYST_DEBUG=${CATALYST_DEBUG:-0}

#/usr/bin/env perl -Ilib ./script/tanktracker_server.pl --port=2500 -r $*
/usr/bin/env perl -Ilib ./script/tanktracker_server.pl -r $*

