#!/bin/bash

cd ~/guntamatic/
PROCESS='./log2rrd.pl'
WATCHED='240 rrd/*.rrd'

STARTER=$PROCESS

LOGFILE='/var/log/wrosner/watchdog_guntamatic.log'
UPDLOG='/var/log/wrosner/guntamatic-poller.log'

RRDTEST=/usr/local/bin/rrdtest.pl

#--------------------------
date >> $LOGFILE

$RRDTEST $WATCHED   2>> $LOGFILE | tail -n1 >> $LOGFILE
STATUS=${PIPESTATUS[0]}
if [ $STATUS -eq 0 ] ; then
	exit
fi

echo -n "guntamatic watchdog triggered at " >> $LOGFILE
date >> $LOGFILE

ps ax | grep "./$PROCESS" | grep '/usr/bin/perl' >> $LOGFILE

killall $PROCESS  >>  $LOGFILE 2>&1
sleep 5
killall -9 $PROCESS  >> $LOGFILE 2>&1
sleep

$STARTER 2>> $UPDLOG 1>> /dev/null   &
echo -n "----- done -----  " >> $LOGFILE
date >> $LOGFILE

