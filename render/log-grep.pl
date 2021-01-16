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

#~~~~ parse @ARGV

my $from = shift @ARGV;
my $until = shift @ARGV;
die "usage: $0 fromtime untiltime { range | times } " unless scalar @ARGV;

my $do_range = scalar grep { /range/ }  @ARGV;
my $do_times = scalar grep { /times/ }  @ARGV;
die "use either 'range'  'times' or both" unless ($do_range or  $do_times)  ;

#~ do work ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print STDERR $cutcmd , "\n"; 

open (my $CUTTED, '-|', $cutcmd) or die " cannot open pipe $cutcmd";

my $cnt=0;
#~~~~~~ begin main loop
while (<$CUTTED>) {
  $cnt++;
}
#~~~~~~ end main loop
print $cnt , " lines found\n";

close $CUTTED;



