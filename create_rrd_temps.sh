#!/bin/bash

/usr/bin/rrdtool create ./rrd/temps.rrd --start 01.10.2020 --step 100s  \
DS:pc_buf:GAUGE:5m:0:100 \
DS:pc_pwr:GAUGE:5m:0:100 \
DS:CO2:GAUGE:5m:0:100 \
DS:T_cald:GAUGE:5m:-20:150 \
DS:T_hw0:GAUGE:5m:-20:150 \
DS:T_buf_top:GAUGE:5m:-20:150 \
DS:T_buf_bot:GAUGE:5m:-20:150 \
DS:T_out:GAUGE:5m:-40:100 \
DS:T_P1:GAUGE:5m:-20:150 \
DS:T_P2:GAUGE:5m:-20:150 \
RRA:AVERAGE:0.5:5m:2y \
RRA:AVERAGE:0.5:1h:10y \
