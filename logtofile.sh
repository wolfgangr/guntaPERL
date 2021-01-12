#!/bin/bash
# was at
# wrosner@homeserver:~/guntamatic$

GHOST=Guntamatic-ph50.rosner.lokal

cd /home/wrosner/guntamatic
# echo -ne "\n[" >>daqdata.log
echo -ne "[" >>daqdata.log
date -u --rfc-3339=seconds | tr  -d '\n' >>daqdata.log 
echo -ne "];" >>daqdata.log
wget -qO - http://${GHOST}/ext/daqdata.cgi?key=22619C862396F373B3FA3E7B276E79C6E563 >> daqdata.log
echo -ne "\n" >>daqdata.log

