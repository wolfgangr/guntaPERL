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

	my $tag = $item_desc->{ tag } ;
	$tag = '' unless  defined $tag ;


	# print $key, ' - ' ;
	printf "id=%03d,  (   %10s   ) ,  %s %s , %s,   %s\n",
		$item_desc->{ id } ,
		$tag, 
		$data[ $key ] ,
		$unit ,			# $item_desc->{ unit } ,
		$item_desc->{ type } ,
		$item_desc->{ name } ,
		;

}

print "\n" ;


print join ' ', map $config{ $_}->{ tag } , (sort numeric_sort   keys %config) ;

print "\n" ;



exit;

#------------------------------------------
# sort helper
sub numeric_sort { $a <=> $b  } 

