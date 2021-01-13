#!/usr/bin/perl
# read config.pm and output debug and devel info
# run after every config change



use Data::Dumper::Simple;
use LWP::Simple;


our %config;
require ('./config.pm');

my $cfg_txt = read_file ('config.pm');
print $cfg_txt;

my $cfg_ptr = eval $cfg_txt;
# my %config = %$cfg_ptr ;
print Dumper (%config);

exit;

#------------------------------------------

sub read_file {
	my $filename = shift;
	my $content = `cat $filename`;
	return $content ;
}
