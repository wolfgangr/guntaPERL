#!/bin/bash

# updating /home/wrosner/guntamatic/rrd/status.rrd, stat=0 
#  - fields: prog_main:prog_HK1:prog_HK2:enbl:opmode:S_op:SP_buf0:SP_hw0:S_P1:S_P2:op_hr 
#  - values: 1610653229:1:2:2:1:0:0:0:0:1:1:1636 


/usr/bin/rrdtool create ./rrd/status.rrd --start N --step 100s  \
DS:prog_main:GAUGE:5m:0:20 \
DS:prog_HK1:GAUGE:5m:0:10 \
DS:prog_HK2:GAUGE:5m:0:10    \
DS:enbl:GAUGE:5m:0:1  \
DS:opmode:GAUGE:5m:0:10 \
DS:S_op:GAUGE:5m:0:1 \
DS:SP_buf0:GAUGE:5m:0:1 \
DS:SP_hw0:GAUGE:5m:0:1 \
DS:S_P1:GAUGE:5m:0:1 \
DS:S_P2:GAUGE:5m:0:1 \
DS:op_hr:COUNTER:5m:0:U \
RRA:LAST:0.5:5m:6M \
RRA:LAST:0.5:1h:2y \
