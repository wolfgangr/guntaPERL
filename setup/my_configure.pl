#!/usr/bin/perl

# this is a crude hack and not a make style configure script!


# find our working and root dir
# customize some helper scripts
# print some basic usage instructions


use warnings;
use strict;

use Cwd qw();


my $servicename = "guntamatic";
my $unit_dir = "/etc/systemd/system";  # this is OK for debian, on other systems this may vary

my $unit_file = "$servicename.service";

my $helpers = qw(rrd2csv.pl rrdtest.pl rnd_sleep.sh);
my $helper_dir = "/usr/local/bin"; 

my $setup_dir= Cwd::getcwd;
my $base_dir= Cwd::abs_path( $setup_dir . '/..');  

print "unit_file: $unit_file \n";
print "setup_dir: $setup_dir \n"; 
print "base_dir:  $base_dir \n" ;

die "DEBUG";



my $installer_template = <<"EOF_INSTALLER";
cp -i ./$unit_file $unit_dir/$unit_ifile
$install_helpers

systemctl daemon-reload
systemctl start $unit_file
echo "started service $unit_file"
echo "entering watchdog - hit ^C to return"
sleep 3
watch -n1 systemctl status

EOF_INSTALLER

# maybe this is BS? have the starter script resident readily?

my $script_template = << 'EOF_SCRIPT_TPL';
#!/bin/bash

echo "htg.service: ## Starting ##" | systemd-cat -p info

# SLEEP=`cat ~/test/systemd/sleep.time`

while :
do
        SLEEP=`cat  ~/test/systemd/sleep.time`
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        # echo "htg.service: timestamp ${TIMESTAMP}" | systemd-cat -p info
        # echo -n "sleeptime is $SLEEP : "
        echo "htg.service: timestamp ${TIMESTAMP} - sleeptime ${SLEEP} "
        systemd-notify 'WATCHDOG=1'
        sleep $SLEEP
done
EOF_SCRIPT_TPL

my $unit_file_template = << "EOF_UF_TPL";i
#  see man systemd.service — Service unit configuration
[Unit]
Description=Guntamatic data logger 

Wants=network.target
After=syslog.target network-online.target

[Service]
Type=notify
# ExecStartPost= ... watchdog???
ExecStart=$setup_dir/start.sh
# ExecStart=$base_dir/log2rrd.pl
Restart=on-failure
RestartSec=120
TimeoutStartSec=180
WatchdogSec=240
# man systemd.kill — Process killing procedure configuration
# KillMode=process
KillMode=control-group
TimeoutStopSec=30

[Install]
WantedBy=multi-user.target
EOF_UF_TPL


# foo 

