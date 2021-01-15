#!/bin/bash

SCRIPTDIR=`dirname "$0"`
cd $SCRIPTDIR

source /etc/profile
source ~/.profile


./log2rrd.pl
