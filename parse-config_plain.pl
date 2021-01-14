#!/usr/bin/perl
# read config_plain.pm and output debug and devel info
# run after every config change

use warnings;
use strict;


use Data::Dumper::Simple;
use LWP::Simple;


our (%config, %selectors, %config_by_tag );
our ($desc_url, $data_url);
our %credentials;
require ('./config_plain.pm');

print Dumper (%config,  %credentials, $desc_url,  $data_url);
print Dumper ( %config_by_tag) ;

my $data_string = get ( $data_url)  or die " cannot retrieve boiler data $data_url";
print $data_string, "\n" ;

# die "----------- debug ----------";