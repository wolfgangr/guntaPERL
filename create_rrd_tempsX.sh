#!/bin/bash

/usr/bin/rrdtool create ./rrd/tempsX.rrd --start N --step 1m  \
DS:T_ret:GAUGE:1m:0:100 \
DS:pc_exh:GAUGE:1m:0:100 \
DS:pc_vent:GAUGE:1m:0:100 \
DS:pc_stok:GAUGE:1m:0:100 \
DS:I_stok:GAUGE:1m:0:5 \
DS:pc_aug1:GAUGE:1m:0:100 \
DS:I_aug1:GAUGE:1m:0:5 \
DS:pc_grt:GAUGE:1m:0:100 \
RRA:AVERAGE:0.5:1m:2w \
RRA:AVERAGE:0.5:5m:6M \
RRA:AVERAGE:0.5:1h:2y \
RRA:MAX:0.5:6h:2y
