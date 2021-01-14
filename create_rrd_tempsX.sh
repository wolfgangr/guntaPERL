#!/bin/bash

/usr/bin/rrdtool create ./rrd/tempsX.rrd --start N --step 100s  \
DS:T_ret:GAUGE:5m:0:100 \
DS:pc_exh:GAUGE:5m:0:100 \
DS:pc_vent:GAUGE:5m:0:100 \
DS:pc_stok:GAUGE:5m:0:100 \
DS:I_stok:GAUGE:5m:0:5 \
DS:pc_aug1:GAUGE:5m:0:100 \
DS:I_aug1:GAUGE:5m:0:5 \
DS:pc_grt:GAUGE:5m:0:100 \
RRA:AVERAGE:0.5:5m:6M \
RRA:AVERAGE:0.5:1h:2y \
RRA:MAX:0.5:6h:2y
