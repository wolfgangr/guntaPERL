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


my $fields = [ qw(  prog_main prog_HK1 prog_HK2 enbl opmode S_op SP_buf0 SP_hw0 S_P1 S_P2 op_hr) ] ;
my $f_colors = [ ('#ff0000') x 11 ] ;
# my $fields =$selectors{ status } ;
my $rrd_dir = "/home/wrosner/guntamatic/rrd";

my $v_spc = 10;
my $v_jmp = 2;
my $v_off =10;

my $title = "Guntamatic status test";

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

printf "--title=%s\n" , $title  if $title  ;

for my $tag (@$fields) {
	printf  "DEF:def_%s=%s/%s.rrd:%s:%s\n", 
		$tag, $rrd_dir, $tags_to_rrd{ $tag }, $tag , $tags_to_cf{$tag }  ;
}


for my $i (0 ..  $#$fields) {
	my $tag = $$fields[ $i ];

	my $def_ = 'def_' . $tag;
        my $cz   = 'Z_' . $tag;
	my $cv   = 'V_' . $tag;
	my $cu   = 'U_' . $tag;	

	my $vert_Z = $i * $v_spc + $v_off;
	my $vert_U =  $vert_Z;
	my $vert_V =  $vert_Z + $v_jmp ;

	 
	#  CDEF:N=K,0,EQ,106,UNKN,IF \  ' Z ero
	printf "CDEF:%s=%s,0,EQ,%d,UNKN,IF \n", 
		$cz, $def_, $vert_Z ;

	#  CDEF:O=K,110,UNKN,IF \	' V alue 
	printf "CDEF:%s=%s,%d,UNKN,IF \n",
		$cv, $def_, $vert_V;

	#  CDEF:P=K,UN,108,UNKN,IF \	' U nknown
	printf "CDEF:%s=%s,UN,%d,UNKN,IF \n",
		$cu, $def_, $vert_U;



	#  LINE3:N#FF0000:  \  medium red - Z
	printf "LINE2:%s#FF0000:\n", $cz;

	#  LINE3:O#008000:  \ thick green - V
	printf "LINE3:%s#008800:\n", $cv;

	#  LINE1:P#808080:  tiny grey - U
	printf "LINE1:%s#008800:\n", $cu;


}




