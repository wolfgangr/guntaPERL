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

my $printf_fmt = "id=%03d,  (   %10s   ) ,  %s %s , %s,   %s\n";

for my $key (sort numeric_sort   keys %config) {
	print_config_item ( $data[ $key ]  , $config{ $key } , $printf_fmt );
  if (0) {
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
}

print "\n" ;

my @check_select = map $config{ $_}->{ tag } , (sort numeric_sort   keys %config) ;
print join ' ', @check_select ; 



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



