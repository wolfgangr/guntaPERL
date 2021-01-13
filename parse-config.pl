#!/usr/bin/perl
# read config.pm and output debug and devel info
# run after every config change



use Data::Dumper::Simple;
use LWP::Simple;


our %config;
require ('./config.pm');

print Dumper (%config);

exit;

#------------------------------------------


