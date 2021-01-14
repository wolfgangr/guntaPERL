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

require ('./library.pm');

print Dumper (%config) ;  
print Dumper (	$desc_url,  $data_url);
print Dumper ( %config_by_tag) ;

# my $data_string = get ( $data_url)  or die " cannot retrieve boiler data $data_url";

my @data = retrieve ( $data_url) or die " cannot retrieve boiler data $data_url";
print Dumper  (@data);

# reuseable for formated output
my $printf_fmt = "id=%03d,  (   %10s   ) ,  %s %s , %s,   %s\n";

# list all configured items with current data in it
for my $key (sort numeric_sort   keys %config) {
	my $di = numbrify ( $data[ $key ]  , $config{ $key } );
	print_config_item ( $di  , $config{ $key } , $printf_fmt );
}
print "\n" ;

our @plain_xtra_index;
print "just the extra items:\n" ;
for  my $key (@plain_xtra_index) {
        print $config{ $key }->{ tag } , ' ';
}
print "\n" ;

for  my $key (@plain_xtra_index) {
        print_config_item ( $data[ $key ]  , $config{ $key } , $printf_fmt );
}
print "\n" ;


die "----------- debug ----------";


# print $data_string, "\n" ;

# die "----------- debug ----------";
#

exit ;
# ~~~~ subs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


