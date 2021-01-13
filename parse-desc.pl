#!/usr/bin/perl
# try to parse daqdesc.cgi from guntamatic heater
# and to provie meaning and configurability to log data

use Data::Dumper;
use JSON;
use Data::Dumper::Simple;
use LWP::Simple;
# use Data::Dumper;

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

my $decoded = JSON::XS::decode_json($desc);

# my $decoded =  JSON::XS->new->utf8->decode($desc);
# my $decoded = JSON::XS::get_ascii($desc);

# my $decoder = new JSON::XS->new;
# $decoder->latin1(1) ;
# $decoder->utf8 ;

# my  $decoded = $decoder->decode($desc);

print Dumper ($decoded) ;

my %desc_by_id;
for $di ( @$decoded ) {
	my $id = $$di{ id};
	my $unit = $$di{ unit};
	 $unit =~ s/\x{b0}/°/ ; # crude hack, better understand utf and bretheren....
	 $$di{ unit} =  $unit;
	printf "id=%03d, unit=%s, type=%s, name=%s\n", $id,  $unit, $$di{ type},$$di{ name}, ;
	$desc_by_id{ $id } = $di;
}

print Dumper ( %desc_by_id );
dump_to_file ( \%desc_by_id, 'desc_by_id.tmp');

my @dat_ary = split ( '\n', $data ) ;


print Dumper ( @dat_ary );

for $dat_row (0 .. $#dat_ary ) {

	$dat_item = $dat_ary[ $dat_row ];
	# next if ( $dat_item  =~ /^\s*$/ )   ;
	

	$di = $desc_by_id{ $dat_row };

	# these seem to be unused vars
	next if ( $$di{ name} =~ /^\s*$/ )   ;
	next if ($dat_item == -20 ) ;
	next if ($dat_item == -100 ) ;
	next if ($dat_item == -9 ) ;
	
	my $name = $$di{ name};
	$name =~ s/\x{e4}/ä/ ;

	next if $name =~ /.*HK\s*[0,3-8]$/ ;
	next if $name =~ /.*Ist\s*[0,3-8]$/ ;
	next if $name =~ /Zusatzwarmw/;
	next if $name =~ /P Warmwasser\s*[1-3]/;
	next if $name =~ /Fernpumpe/;
	next if $name =~ /Brennstoffz/;

	# my $id = $$di{ id};
	# my $unit = $$di{ unit};
	# $unit =~ s/\x{b0}/°/ ;

	printf "id=%03d, value=%s, unit=%s, type=%s, name=%s\n", $id, $dat_item,  $$di{ unit} , $$di{ type}, $name, ;
}



exit ;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# dump_to_file { \somevar, $filename }
sub dump_to_file {
	my ( $varptr, $filename ) = @_; 


	open ( $FILE, '>', $filename ) or die "cannot open $filename for writing";

	#if (0) { 
	{
		# $Data::Dumper::Sortkeys 
		local $Data::Dumper::Terse = 1;
		local $Data::Dumper::Sortkeys = sub { [sort { $a <=> $b } keys %{$_[0]}] };
		print $FILE Data::Dumper->Dump([$varptr]); 
	}

	# my $my_dump =  Data::Dumper->new(

	close $FILE;

}


