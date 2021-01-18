#!/bin/bash

# systemd starter script

SCRIPTDIR=`dirname "$0"`
cd $SCRIPTDIR

# spawn our associated babysitter
./watchdog.sh &

cd ..
# not sure what environment we get from systemd
source /etc/profile
source ~/.profile


./log2rrd.pl &

# does this help to report success to sysstemd?
exit 0
