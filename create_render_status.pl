#!/usr/bin/perl
# read config_plain.pm and output debug and devel info
# run after every config change

use warnings;
use strict;


use Data::Dumper::Simple;

our (%config, %selectors, %config_by_tag , %RRD_list);
# our ($desc_url, $data_url);
# our %credentials;
require ('./config_plain.pm');


# $fields => qw(  prog_main prog_HK1 prog_HK2 enbl opmode S_op SP_buf0 SP_hiw0 S_P1 S_P2 op_hr) ;
my $fields =$selectors{ status } ;
my $rrd_dir = "/home/wrosner/guntamatic/rrd";

print "--title=Guntamatic status test\n";

# I need a reverse mapping of tags -> rrd file

my %tags_to_rrd ;
my %tags_to_cf ;
for my $rrd (keys %RRD_list) {
	my $sel = $selectors{ $rrd } ;
	next unless defined $sel;
	next unless scalar @$sel;

	my $cf='AVERAGE'; # the default
	my $rrdl = $RRD_list{ $rrd } ;
	if (defined $rrdl->{ stat } and $rrdl->{ stat } ) {
		$cf = 'LAST'; # for the stat rrds
	}
	        	
	for my $tag (@$sel) {
		$tags_to_rrd{$tag } = $rrd ;
		$tags_to_cf{$tag } =  $cf;
	}
}

print STDERR Dumper (\%tags_to_rrd, \%tags_to_cf);
print STDERR Dumper (\$fields);

for my $tag (@$fields) {
	printf  "DEF:def_%s=%s/%s.rrd:%s:%s\n", 
		$tag, $rrd_dir, $tags_to_rrd{ $tag }, $tag , $tags_to_cf{$tag }  ;
}

