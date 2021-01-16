#!/usr/bin/perl
#
# grep log file by time and return either line range , time list  or line times
# assume sorted entries
#
# intended consumer:
# time tail -n+10000 ../olddata/daqdata.log.2 | head -n3
#
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

my $cnt_start=0;
my $cnt_lines=0;
 
#~~~~~~ begin main loop
# be efficient, no sanity checking
while (<$CUTTED>) {

	unless ($cnt_lines) {
		$cnt_start++;
		next if ($_ < $from);
	}
 	last if ( $_ > $until) ; 
	$cnt_lines++;

	if ($do_times) { print $_ ; }
}
#~~~~~~ end main loop
# print $cnt , " lines found\n";
if ($do_range) { printf "%s %s\n", $cnt_start, $cnt_lines }


close $CUTTED;



