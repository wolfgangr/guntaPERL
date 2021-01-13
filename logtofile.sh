#!/bin/bash
# was at


GHOST=Guntamatic-ph50.my.host

cd /home/foobar/guntamatic
# echo -ne "\n[" >>daqdata.log
echo -ne "[" >>daqdata.log
date -u --rfc-3339=seconds | tr  -d '\n' >>daqdata.log 
echo -ne "];" >>daqdata.log
wget -qO - http://${GHOST}/ext/daqdata.cgi?key=1234567 >> daqdata.log
echo -ne "\n" >>daqdata.log

