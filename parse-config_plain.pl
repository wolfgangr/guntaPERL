#!/usr/bin/perl
# read config_plain.pm and output debug and devel info
# run after every config change

use warnings;
use strict;


use Data::Dumper::Simple;
use LWP::Simple;


our (%config, %selectors, %config_by_tag );
our ($desc_url, $data_url);
# our %credentials;
require ('./config_plain.pm');

print Dumper (%config) ;  
print Dumper (	$desc_url,  $data_url);
print Dumper ( %config_by_tag) ;

my $data_string = get ( $data_url)  or die " cannot retrieve boiler data $data_url";
# print $data_string, "\n" ;

# die "----------- debug ----------";
#

exit ;
# ~~~~ subs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# https://www.linuxquestions.org/questions/programming-9/how-to-compare-two-lists-arrays-in-perl-636686/#post3128140
# @rest = set_difference ( \@major, \@minor )
sub set_difference {
	my ($major, $minor) = @_;
	my @A = @$major;
	my @B = @$minor;

	# no need to understand as long as it works ;-)
	my @C=grep!${{map{$_,1}@B}}{$_},@A;
	# my @C=map{!${{map{$_,1}@B}}{$_}&&$_||undef}@A;
	return @C;
}


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
