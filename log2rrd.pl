#!/usr/bin/perl
# read config_plain.pm and output debug and devel info
# run after every config change

use warnings;
use strict;


use Data::Dumper::Simple;
use LWP::Simple;

my $debug = 5;

our (%config, %selectors, %config_by_tag );
our ($desc_url, $data_url);
our (%RRD_list,  %selectors);
# our %credentials;
require ('./config_plain.pm');

require ('./library.pm');

if ($debug >=5 ) {
	print Dumper (%config) ;  
	print Dumper (	$desc_url,  $data_url);
	print Dumper ( %config_by_tag) ;
	print Dumper (%RRD_list,  %selectors);
}
