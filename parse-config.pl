#!/usr/bin/perl
# read config.pm and output debug and devel info
# run after every config change



use Data::Dumper::Simple;
use LWP::Simple;


our %config;
our $desc_url, $data_url;
our %credentials;
require ('./config.pm');


print Dumper (%config,  %credentials, $desc_url, $data_url);

my $data = get ( $data_url)  or die " cannot retrieve boiler data $data_url";
print $data, "\n" ;



exit;

#------------------------------------------


