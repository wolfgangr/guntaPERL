#!/usr/bin/perl

# read guntamatic log records as written by logtofile.sh
# format
# [2021-01-12 21:22:03+00:00];[69.61,-100.00,-100.00,-20.00,40,17.98,

use warnings;
use strict;


use Data::Dumper::Simple;
# use LWP::Simple;
use JSON;

our (%config, %selectors, %config_by_tag );
our ($desc_url, $data_url);
our %credentials;
our ( @js_index, %js_rev_index);
require ('./config.pm');


my $filename = shift  @ARGV or die "usage: $0 filename-log";

open (my $FILE, '<', $filename) or die "cannot open $filename";


while (<$FILE>) {
	# my ($dt, $vals) = $_ =~   /^\[(.*)\];\[(.*)\]$/ ;
	my ($dt, $vals) = $_ =~   /^\[(.*)\];(\[.*\])$/ ;
	
	#  date -d'2020-12-31 23:05:02+00:00' +%s
	my $unixtime = `date -d'$dt' +%s`;
	chomp $unixtime;
	
	# manually or JSON decoder?
	
	# my @values = split ( ',' ,  $vals);
	my $v_p = JSON::XS::decode_json($vals);
	my @values = @$v_p;

	# I want tag -> value pairs
	my %tv;

	for my $i (0 .. $#values) {
		my $val = $values[  $i ] ;
		my $id = $js_index[ $i ] ;

		# use only configured values
		my $tag = $config{ $id }->{ tag } ;
		next unless defined $tag ;

		printf "\t ID=%03d, tag=%s,       \t value=%s  \n", $id,  $tag,  $val;

		$tv{$tag} = $val;
	}
	print Dumper ( %tv);

	# print "  -> found values: ", scalar @values ;
	# print "\n";
	printf " at time %s = %011d found %d data fields \n", $dt, $unixtime, scalar @values ;
	

	die "========================== DEBUG ==========================";

}

close $FILE;


