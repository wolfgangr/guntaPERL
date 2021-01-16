#!/usr/bin/perl
#
# grep log file by time and return either line range , time list  or line times
# usage:
# grep-log.pl fromtime untiltime { from | to | 
# by Wolfgang Rosner, 2021

use warnings;
use strict;

my $logfile = './status.log';

# cut -d':' -f4 status.log
my $cutcmd = `which cut`;
chomp $cutcmd ;
$cutcmd .= "  -d':' -f4  ";
$cutcmd .= $logfile ;

print STDERR $cutcmd , "\n"; 

open (my $CUTTED, '-|', $cutcmd) or die " cannot open pipe $cutcmd";

my $cnt=0;
while (<$CUTTED>) {
  $cnt++;
}

print $cnt , " lines found\n";

close $CUTTED;



