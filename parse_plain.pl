#!/usr/bin/perl
# try to parse daqdesc.cgi from guntamatic heater old api under /, not under /ext/
# this one speaks plain text, line separated, and has some more items than the /ext/-JSON
#

use warnings;
use strict;

use Data::Dumper;
# use JSON;
use Data::Dumper::Simple;
use LWP::Simple ; # () ;
# use utf8;
use Encode qw( encode decode);


my $dumpfile = './test/parse_plain.out';



our (%config, %selectors, %config_by_tag );
# our ($desc_url, $data_url);
# our %credentials;
our ( @js_index, %js_rev_index);
our (@plain_index, @plain_xtra_index, %plain_rev_index);
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


# printf "recieved %d lines of data and %d lines of desc \n", scalar @data_ary, scalar @desc_ary ;

my %config_plain ;
for my $i (0 .. $#desc_ary) {
	printf "%03d - %s -  \t %s\n", $i , $data_ary[ $i ], $desc_ary[ $i ] ; 

	my ($name , $unit) = split ( ';', $desc_ary[ $i ] ) ;
	my %c_item = ( id => $i, unit => $unit, name => $name );

	unless ($name eq 'reserved'  ) {
		$config_plain{ $i } = \%c_item ;
	} else {
		next if ( $data_ary[ $i ] eq ' '  );
		die " found value for reserved item ";
	}

	# $config_plain{ $i } = \%c_item ; 
}

print Dumper ( %config_plain );

# print Dumper (%plain_rev_index);

my @c_keys_plain = sort numeric_sort (keys %config_plain ) ;
my @c_keys_json  =  @js_index ;    # sort numeric_sort (keys %config ) ;
my @c_plain_butnotJ = set_difference( \@c_keys_plain, \@c_keys_json   );
my @c_json_butnotP  = set_difference( \@c_keys_json , \@c_keys_plain  );


print (join ", " , @c_keys_plain)  ;
print "\n" ;
print (join ", " , @plain_index)  ;
print "\n" ;

printf "recieved %d lines of data and %d lines of desc of which %d are valid\n", 
	scalar @data_ary, scalar @desc_ary , scalar keys %config_plain ;
printf "plain: %d, JSON: %d, plain &! JSON: %d, JSON &! plain: %d\n", 
	scalar  @c_keys_plain, scalar @c_keys_json, 
	scalar @c_plain_butnotJ , scalar @c_json_butnotP ;

print (join ", " , @c_plain_butnotJ)  ;
print "\n" ;

my %config_xtra ;
for my $i (@c_plain_butnotJ) {
	printf "%03d - %s -  \t %s\n", $i , $data_ary[ $i ], $desc_ary[ $i ] ;
	$config_xtra{ $i } = $config_plain{ $i } ;
}
# print Dumper ( \%config_xtra );


# merge json config into plain
# cycle over configrued fileds in JSON
for my $id (@js_index ) {
	my %c_p = %{$config_plain { $id }} ;
	$c_p{'JSON'} = 0;			# this key is in JSON set but was not configured
	if ( defined $config{ $id } ) {  		# not all are conf'd

		my %c_j = %{$config{ $id }} ;
		# get the match in 'plain'
		# my %c_p = %{$config_plain { $id }} ;
		# for all keys
		for my $k (keys %c_j) {
			next if $c_p{ $k  };  		# 'plain' def has preference
			$c_p{ $k  } = $c_j{ $k  } ; 	# otherwise: copy over
		}
		$c_p{'JSON'} = 1; 			# kilroy
	}
	$config_plain { $id } = \%c_p ;		# we cowardly worked on a copy
}

print Dumper ( \%config_plain );


dump_to_file ( \%config_plain , $dumpfile );

# my @c_plain_keys = sort numeric_sort (keys %config_plain )

exit ;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @values = retrieve ($url) 
sub retrieve {
	my $url = shift;
	my $rsp_utf8 =  get ( $url );
	my $rsp = encode("UTF-8", $rsp_utf8);
	return split ( '\n', $rsp ) ;
}

# https://www.linuxquestions.org/questions/programming-9/how-to-compare-two-lists-arrays-in-perl-636686/#post3128140
# @rest = set_difference ( \@major, \@minor )
sub set_difference {
	my ($major, $minor) = @_;
	my @A = @$major;
	my @B = @$minor;

	# no need to understand as long as it works ;-)
	my @C=grep!${{map{$_,1}@B}}{$_},@A;
	# my @C=map{!${{map{$_,1}@B}}{$_}&&$_||undef}@A;
	return @C;
}

# dump_to_file ( \somevar, $filename )
sub dump_to_file {
	my ( $varptr, $filename ) = @_; 


	open ( my $FILE, '>', $filename ) or die "cannot open $filename for writing";

	#if (0) { 
	{
		# $Data::Dumper::Sortkeys 
		local $Data::Dumper::Terse = 1;
		local $Data::Dumper::Sortkeys = sub { [sort numeric_sort keys %{$_[0]}] };
		print $FILE Data::Dumper->Dump([$varptr]); 
	}

	# my $my_dump =  Data::Dumper->new(

	close $FILE;

}
