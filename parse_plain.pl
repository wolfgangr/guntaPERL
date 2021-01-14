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
# our ( @js_index, %js_rev_index);
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


printf "recieved %d lines of data and %d lines of desc \n", scalar @data_ary, scalar @desc_ary ;

for my $i (0 .. $#desc_ary) {
	printf "%03d - %s -  \t %s\n", $i , $data_ary[ $i ], $desc_ary[ $i ] ; 
}


exit ;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @values = retrieve ($url) 
sub retrieve {
	my $url = shift;
	my $rsp_utf8 =  get ( $url );
	my $rsp = encode("UTF-8", $desc_utf8);
	return split ( '\n', $data ) ;
}
