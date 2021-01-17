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

my $unit_file = "$unit_dir/$servicename.service";

my $setup_dir= Cwd::getcwd;
my $base_dir= Cwd::abs_path( $setup_dir . '/..');  

print "unit_file: $unit_file \n";
print "setup_dir: $setup_dir \n"; 
print "base_dir:  $base_dir \n" ;

die "DEBUG";



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


my $unit_file_template = << "EOF_UF_TPL";
[Unit]
Description=How-To Geek Service Example

Wants=network.target
After=syslog.target network-online.target

[Service]
Type=notify
ExecStart=/usr/local/bin/htg.sh
Restart=on-failure
RestartSec=30
TimeoutStartSec=330
WatchdogSec=30
KillMode=process

[Install]
WantedBy=multi-user.target
EOF_UF_TPL


# foo 

