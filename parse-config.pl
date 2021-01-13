#!/usr/bin/perl
# read config.pm and output debug and devel info
# run after every config change



use Data::Dumper::Simple;
use LWP::Simple;


our %config;
our $desc_url, $data_url;
our %credentials;
require ('./config.pm');

# our %credentials;
# require ('./secret.pm');
# my $data_url =  'http://' . $credentials{ host } ;
# $data_url .=  $credentials{ data_api } ;
# $data_url .= '?key=' . $credentials{ key } ;


print Dumper (%config,  %credentials, $desc_url, $data_url);

# print $desc_url;
# print $data_url, "\n" ;

my $data = get ( $data_url)  or die " cannot retrieve boiler data $data_url";
print $data, "\n" ;



exit;

#------------------------------------------


