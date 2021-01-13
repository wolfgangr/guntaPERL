#!/usr/bin/perl
#
#


use warnings;
use strict;

use Data::Dumper::Simple ;


my $checkfile = './test/par.cgi' ;

open ( my $IN, '<', $checkfile) or die "cannot read from  $checkfile";


while (<$IN>) {
	# ^([A-Z]{2}\d{3});(\d+);\d+;(\d+);[^;]+;[^;]+;[^;]+;[^;]+;[^;]+;(.*);$
	my ($param, $ptype , $num_tags, $tags) = ($_ =~ /^([A-Z]{2}\d{3});(\d+);\d+;(\d+);[^;]+;[^;]+;[^;]+;[^;]+;[^;]+;(.*);$/ )  ;

	next unless (defined $ptype) ;
	next unless ($ptype  == 6);
	next if ($tags  eq 'Nein;Ja' );
	my @tag_list = split (';', $tags );
	# next unless scalar @tag_list;
	# next unless ($ptype  == 6);

	print $_ ;
	printf "param=%s,  ptype=%d, num_tags=%d, tag#=%d \n", 
		$param, $ptype , $num_tags, scalar @tag_list ;
}


close  $IN;
exit
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
