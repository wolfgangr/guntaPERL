#!/usr/bin/perl

# read guntamatic log records as written by logtofile.sh
# format
# [2021-01-12 21:22:03+00:00];[69.61,-100.00,-100.00,-20.00,40,17.98,

use warnings;
use strict;

use Data::Dumper::Simple ;
# use LWP::Simple;
use JSON() ;
use RRDs() ;


# hack to produce 60s- updates
my $fake_intvl = 60; # produce updates for every 60s
my $fake_max = 10 ;  # but not more than 10 per real dataset

my $rrd_temps = './rrd/temps.rrd';
# my $rrd_status = './rrd/status.rrd';
# my $rrd_extra = './rrd/extra.rrd';


our (%config, %selectors, %config_by_tag );
our ($desc_url, $data_url);
our %credentials;
our ( @js_index, %js_rev_index);
require ('./config.pm');


my $filename = shift  @ARGV or die "usage: $0 filename-log";

open (my $FILE, '<', $filename) or die "cannot open $filename";

my $lastupdate =0;
while (<$FILE>) {
	# my ($dt, $vals) = $_ =~   /^\[(.*)\];\[(.*)\]$/ ;
	my ($dt, $vals) = $_ =~   /^\[(.*)\];(\[.*\])$/ ;
	
	#  date -d'2020-12-31 23:05:02+00:00' +%s
	my $unixtime = `date -d'$dt' +%s`;
	chomp $unixtime;

	next unless $vals;

	# manually or JSON decoder?
	
	# my @values = split ( ',' ,  $vals);
	my $v_p = JSON::XS::decode_json($vals);
	my @values = @$v_p;

	# I want tag -> value pairs
	my %tv;

	for my $i (0 .. $#values) {
		my $val = $values[  $i ] ;
		my $id = $js_index[ $i ] ;

		# use only configured values
		my $tag = $config{ $id }->{ tag } ;
		next unless defined $tag ;

		### printf "\t ID=%03d, tag=%s,       \t value=%s  \n", $id,  $tag,  $val;

		$tv{$tag} = $val;
	}
	# print Dumper ( %tv);

	# print "  -> found values: ", scalar @values ;
	# print "\n";
	### printf " at time %s = %011d found %d data fields \n", $dt, $unixtime, scalar @values ;

	my @taglist = @{$selectors{ rrd }} ;
	my $rrd_template = join (':', @taglist);
	# print $rrd_template , "\n";

	my @rrd_values = map { $tv{ $_ }   } @taglist;
	my $rrd_values = join (':',  @rrd_values);
	# print $rrd_values , "\n";

	#~~~~~~~~~~~~ time faking for rrd boundaries
	
	$unixtime -= $unixtime % $fake_intvl ;
 	my $fake_time;
	if ( ($unixtime - $lastupdate)  <= ( $fake_intvl *  $fake_max ) ) {
		$fake_time = $lastupdate;
	} else {
		$fake_time = $unixtime - ($fake_intvl *  $fake_max ) ;
	}
	$lastupdate = $unixtime; 
# ~~~~~~~~~~~
    for ( ; $fake_time <= $unixtime ; $fake_time += $fake_intvl) {

	RRDs::update($rrd_temps,  '--skip-past-updates' , '--template', $rrd_template, $fake_time . ':' .   $rrd_values);
	if ( RRDs::error ) {
		printf STDERR ( "error updating RRD %s: %s \n", $rrd_temps , RRDs::error ) ;
		# die "rrd update error";
	}
    }
# ~~~~~~~~~~~~~~~~~
    # die "========================== DEBUG ==========================";

}

close $FILE;


