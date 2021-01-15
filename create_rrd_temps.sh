#!/bin/bash

/usr/bin/rrdtool create ./rrd/temps.rrd --start 01.10.2020 --step 1m  \
DS:pc_buf:GAUGE:1m:0:100 \
DS:pc_pwr:GAUGE:1m:0:100 \
DS:CO2:GAUGE:1m:0:100 \
DS:T_cald:GAUGE:1m:-20:150 \
DS:T_hw0:GAUGE:1m:-20:150 \
DS:T_buf_top:GAUGE:1m:-20:150 \
DS:T_buf_bot:GAUGE:1m:-20:150 \
DS:T_out:GAUGE:1m:-40:100 \
DS:T_P1:GAUGE:1m:-20:150 \
DS:T_P2:GAUGE:1m:-20:150 \
RRA:AVERAGE:0.5:1m:2w \
RRA:AVERAGE:0.5:5m:2y \
RRA:AVERAGE:0.5:1h:10y \
