#!/usr/bin/perl
# try to parse daqdesc.cgi from guntamatic heater old api under /, not under /ext/
# this one speaks plain text, line separated, and has some more items than the /ext/-JSON
#

use warnings;
use strict;

# use Data::Dumper;
# use JSON;
use Data::Dumper::Simple;
use LWP::Simple ; # () ;
# use utf8;
use Encode qw( encode decode);


our (%config, %selectors, %config_by_tag );
# our ($desc_url, $data_url);
# our %credentials;
our ( @js_index, %js_rev_index);
# our ($desc_url_plain, $data_url_plain, $desc_url_json, $data_url_json) ;
our ($desc_url_plain, $data_url_plain);
require ('./config.pm');

printf "%s\n" , $desc_url_plain ;
printf "%s\n" , $data_url_plain ;
# printf "%s\n" , $desc_url_json ;
# printf "%s\n" , $data_url_json ;

# LWP::Simple web retrieve
# my $desc_utf8 = get ( $desc_url_plain)  or die " cannot retrieve $desc_url_plain";
# my $data_utf8 = get ( $data_url_plain)  or die " cannot retrieve $data_url_plain";

# my $desc = utf8::decode($desc_utf);
# utf8::upgrade($desc);
# my $desc = encode("UTF-8", $desc_utf8);
# my $data = encode("UTF-8", $data_utf8);


# my @data_ary = split ( '\n', $data ) ;
# my @desc_ary = split ( '\n', $desc ) ;

my @data_ary = retrieve ( $data_url_plain) ;
my @desc_ary = retrieve ( $desc_url_plain) ;


# printf "recieved %d lines of data and %d lines of desc \n", scalar @data_ary, scalar @desc_ary ;

my %config_plain ;
for my $i (0 .. $#desc_ary) {
	printf "%03d - %s -  \t %s\n", $i , $data_ary[ $i ], $desc_ary[ $i ] ; 

	my ($name , $unit) = split ( ';', $desc_ary[ $i ] ) ;
	my %c_item = ( id => $i, unit => $unit, name => $name );

	unless ($name eq 'reserved'  ) {
		$config_plain{ $i } = \%c_item ;
	} else {
		next if ( $data_ary[ $i ] eq ' '  );
		die " found value for reserved item ";
	}

	# $config_plain{ $i } = \%c_item ; 
}

print Dumper ( %config_plain );

my @c_keys_plain = sort numeric_sort (keys %config_plain ) ;
my @c_keys_json  =  @js_index ;    # sort numeric_sort (keys %config ) ;
my @c_plain_butnotJ = set_difference( \@c_keys_plain, \@c_keys_json   );
my @c_json_butnotP  = set_difference( \@c_keys_json , \@c_keys_plain  );


print (join ", " , @c_keys_plain)  ;
print "\n  " ;
printf "recieved %d lines of data and %d lines of desc of which %d are valid\n", 
	scalar @data_ary, scalar @desc_ary , scalar keys %config_plain ;
printf "plain: %d, JSON: %d, plain &! JSON: %d, JSON &! plain: %d\n", 
	scalar  @c_keys_plain, scalar @c_keys_json, 
	scalar @c_plain_butnotJ , scalar @c_json_butnotP ;


# my @c_plain_keys = sort numeric_sort (keys %config_plain )

exit ;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @values = retrieve ($url) 
sub retrieve {
	my $url = shift;
	my $rsp_utf8 =  get ( $url );
	my $rsp = encode("UTF-8", $rsp_utf8);
	return split ( '\n', $rsp ) ;
}

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


