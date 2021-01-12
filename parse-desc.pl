#!/usr/bin/perl
# try to parse daqdesc.cgi from guntamatic heater
# and to provie meaning and configurability to log data

use Data::Dumper::Simple;
use LWP::Simple;


# http://${GHOST}/ext/daqdata.cgi?key=22619C862396F373B3FA3E7B276E79C6E563 
my $data_api = '/daqdata.cgi' ;
my $desc_api = '/ext/daqdesc.cgi' ;
# my $http = 'http://';

my $secret_file = 'secret.key';
my $secret_pwd = `cat $secret_file` ;

# print $secret_pwd;

my %credentials;
for ( split '\n' , $secret_pwd ) {
	next if /^#/ ; # skip comment lines
	my ($tag, $val) = split '=' , $_, 2;
	next unless $tag ;
	$val =~ s/"?([^"]*)?"/$1/ ;  # strip quotes
	$credentials{ $tag } = $val ;
}

print Dumper ( %credentials );


my $desc_url =  'http://' . $credentials{ host } .  $desc_api . '?key=' . $credentials{ key } ;
my $data_url =  'http://' . $credentials{ host } .  $data_api . '?key=' . $credentials{ key } ;

print $desc_url, "\n" ;
print $data_url, "\n" ;

my $desc = get ( $desc_url)  or die " cannot retrieve $desc_url";
my $data = get ( $data_url)  or die " cannot retrieve $data_url";

print $desc, "\n" ;
print $data, "\n" ;


