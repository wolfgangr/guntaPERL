#!/bin/bash


./create_rrd_status.sh
./create_rrd_statusX.sh
# ./create_rrd_temps.sh
./create_rrd_tempsX.sh


rm ./rrd/temps.rrd

cd olddata
./get-history2rrd.sh
