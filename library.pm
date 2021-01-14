use warnings;
use strict;

use Data::Dumper;

use LWP::Simple ; # () ;
use Encode qw( encode decode);

# our %config;

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


# print_config_item ( $dat_val, $item, $formatf )
sub print_config_item {
	my ( $dat_val, $item_desc, $formatf ) = @_;

	# my $item_desc = $config{ $key };
	my $unit = $item_desc->{ unit } ;
	$unit = '' unless  defined $unit ;

	my $tag = $item_desc->{ tag } ;
	$tag = '' unless  defined $tag ;

	my $type = $item_desc->{ type } ;
	$type = '' unless  defined $type ;

	my $name = $item_desc->{ name } ;
	# $name = '???' unless  defined $name ;

	# print $key, ' - ' ;
	# printf "id=%03d,  (   %10s   ) ,  %s %s , %s,   %s\n",
	printf $formatf ,
		$item_desc->{ id } ,
		$tag,
		# $data[ $key ] ,
		$dat_val,
		$unit ,			# $item_desc->{ unit } ,
		$type ,
		$name ,
		;
}

use Scalar::Util () ; #qw(looks_like_number);
use List::MoreUtils ();
our @enum_boolean ;

# try to convert to number, undef on failure (check for rrd)
# $number = numbrify( $string, \%config_item )
sub numbrify {
	my ( $string, $cfgip) = @_;
	my %cfg_itm = %{$cfgip} ;
	my $type = $cfg_itm{ type } ;
	if ($type and $type eq 'boolean') {

		if ($string eq $enum_boolean[1] ) {
			return 1;
		} elsif ($string eq $enum_boolean[0]) {
			return 0;
		} else {
			# boolean conversion error
			return undef;
		}

	} elsif ($type and $type eq 'string') {
		# strings are enums in fact
		my @enum = @{$cfg_itm{ enum }} ;
		 
		my $match = List::MoreUtils::first_index { $string eq $_  } @enum ;
		return undef if ($match <0)  ;
		return $match;

	} 
	if ( Scalar::Util::looks_like_number ($string) ) {
		# lookslikenumber?
		return $string+0 ; 
	}
	return undef;
}



1;
