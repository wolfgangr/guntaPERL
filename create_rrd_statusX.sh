#!/bin/bash

# updating /home/wrosner/guntamatic/rrd/statusX.rrd, stat=1 
#  - fields: fault0:fault1:frflp:level:stb:tks1:ign_vnt:ign_ht 
#  - values: 1610654839:U:U:1:1:1:1:0:0 


/usr/bin/rrdtool create ./rrd/statusX.rrd --start N --step 1m  \
DS:fault0:GAUGE:1m:0:20 \
DS:fault1:GAUGE:1m:0:20 \
DS:frflp:GAUGE:1m:0:1 \
DS:level:GAUGE:1m:0:1  \
DS:stb:GAUGE:1m:0:1  \
DS:tks1:GAUGE:1m:0:1  \
DS:ign_vnt:GAUGE:1m:0:1  \
DS:ign_ht:GAUGE:1m:0:1  \
RRA:LAST:0.5:1m:2w \
RRA:AVERAGE:0.5:5m:6M \
RRA:AVERAGE:0.5:1h:2y \
