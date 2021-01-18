#!/bin/bash

# systemd starter script

SCRIPTDIR=`dirname "$0"`
cd $SCRIPTDIR

# spawn our associated babysitter
./watchdog.pl &

# not sure what environment we get from systemd
echo $PATH
cd ..
source /etc/profile
source ~/.profile
echo $PATH

# launch the real thing
./log2rrd.pl &

# report success to sysstemd just in case it's configured to ask for
exit 0
