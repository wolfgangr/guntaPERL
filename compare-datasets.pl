#!/usr/bin/perl

# looks like we have different data outlets?


use warnings;
use strict;

use Data::Dumper::Simple;
use LWP::Simple;
use JSON;

my $data_r_api = '/daqdata.cgi' ;
my $data_e_api = '/ext/daqdata.cgi' ;



our (%config, %selectors, %config_by_tag );
our ($desc_url, $data_url);
our %credentials;
require ('./config.pm');

print Dumper (%credentials);

my $data_r_url =  'http://' . $credentials{ host } ;
$data_r_url .=  $data_r_api ;
$data_r_url .= '?key=' . $credentials{ key } ;


my $data_e_url =  'http://' . $credentials{ host } ;
$data_e_url .=  $data_e_api ;
$data_e_url .= '?key=' . $credentials{ key } ;

printf "data_r_url: %s \n",  $data_r_url ;
printf "data_e_url: %s \n",  $data_e_url ;

my $data_r_str = get $data_r_url ;
my $data_e_str = get $data_e_url ;

print $data_r_str , "\n";
print $data_e_str , "\n";

my @dat_r_ary = split ( '\n', $data_r_str ) ;
printf "\@dat_r_ary has %d records\n" , scalar @dat_r_ary ;

my $data_e_decode = JSON::XS::decode_json($data_e_str);
my @dat_e_ary = @{$data_e_decode} ;
# print Dumper ($data_e_decode);
printf "\@dat_e_ary has %d records\n" , scalar @dat_e_ary ;

my $longconfig = eval `cat desc_by_id.tmp`;

my @js_index = sort numeric_sort keys %{$longconfig} ;
printf "\@js_index has %d records\n" , scalar @js_index ;

print "qw( ", join (' ' , @js_index), " )\n";

# revert that thing
my %js_rev_index;
for (0 .. $#js_index) {
	$js_rev_index{ $js_index[ $_ ] } =  $_ ;
}

# print Dumper (%js_rev_index);

# die "debug";

for my $i (0 ..  $#dat_r_ary) {
	my $js_pos = $js_rev_index{ $i };
	my $_e_data = (defined $js_pos) ? $dat_e_ary[ $js_pos  ]  : '-';

	printf "from /: %s    from /ext/:   %s \n", $dat_r_ary[ $i ], $_e_data ;
}



