#!/usr/bin/perl
# read config.pm and output debug and devel info
# run after every config change

use warnings;
use strict;


use Data::Dumper::Simple;
use LWP::Simple;


our %config;
our ($desc_url, $data_url);
our %credentials;
require ('./config.pm');


print Dumper (%config,  %credentials, $desc_url, $data_url);

my $data_string = get ( $data_url)  or die " cannot retrieve boiler data $data_url";
# print $data_string, "\n" ;

my @data = split ( '\n', $data_string ) ;
printf "data: %s\n", join ( ' : ' , @data );


for my $key (sort numeric_sort   keys %config) {
	my $item_desc = $config{ $key };
	my $unit = $item_desc->{ unit } ;
	$unit = '' unless  defined $unit ;

	# print $key, ' - ' ;
	printf "id=%03d, value=%s, unit=%s, type=%s, name=%s\n",
		$item_desc->{ id } ,
		$data[ $key ] ,
		$unit ,			# $item_desc->{ unit } ,
		$item_desc->{ type } ,
		$item_desc->{ name } ,
		;

}

print "\n" ;

exit;

#------------------------------------------
# sort helper
sub numeric_sort { $a <=> $b  } 

