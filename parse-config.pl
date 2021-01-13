#!/usr/bin/perl
# read config.pm and output debug and devel info
# run after every config change

use warnings;
use strict;


use Data::Dumper::Simple;
use LWP::Simple;


our (%config, %selectors, %config_by_tag );
our ($desc_url, $data_url);
our %credentials;
require ('./config.pm');


print Dumper (%config,  %credentials, $desc_url,  $data_url);
print Dumper ( %config_by_tag) ;

my $data_string = get ( $data_url)  or die " cannot retrieve boiler data $data_url";
# print $data_string, "\n" ;

my @data = split ( '\n', $data_string ) ;
printf "data: %s\n", join ( ' : ' , @data );

# reuseable for formated output
my $printf_fmt = "id=%03d,  (   %10s   ) ,  %s %s , %s,   %s\n";

# list all configured items with current data in it
for my $key (sort numeric_sort   keys %config) {
	print_config_item ( $data[ $key ]  , $config{ $key } , $printf_fmt );
}

print "\n" ;

# map all mnemonic tags from %config to array
my @check_select = map $config{ $_}->{ tag } , (sort numeric_sort   keys %config) ;
print join ' ', @check_select ; 
print  "\n\n" ;

# cycle over selection, print human readable values and a list of missin tags

# print Dumper (%selectors) ;

for my $sl (sort keys %selectors ) {
	my @list = @{$selectors{$sl}};
	print "selector $sl:  \n";
	print " - includes: ", join (' ', @list) , "\n";

	# cycle over tags and print
	for my $s_tag (@list) {
		my $key = $config_by_tag{ $s_tag  }->{ id  } ;
		print_config_item ( $data[ $key ]  , $config{ $key } , $printf_fmt );
	}
	print "\n" ;
}

print "\n" ;



exit;

#------------------------------------------

# print_config_item ( $dat_val, $item, $formatf )
sub print_config_item {
	my ( $dat_val, $item_desc, $formatf ) = @_;

	# my $item_desc = $config{ $key };
	my $unit = $item_desc->{ unit } ;
	$unit = '' unless  defined $unit ;

	my $tag = $item_desc->{ tag } ;
	$tag = '' unless  defined $tag ;


	# print $key, ' - ' ;
	# printf "id=%03d,  (   %10s   ) ,  %s %s , %s,   %s\n",
	printf $formatf ,
		$item_desc->{ id } ,
		$tag,
		# $data[ $key ] ,
		$dat_val,
		$unit ,			# $item_desc->{ unit } ,
		$item_desc->{ type } ,
		$item_desc->{ name } ,
		;



}



