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

my $rrd_temps = './rrd/temps.rrd';
my $status_log = '/var/log/wrosner/guntamatic-status.log' ;
# my $rrd_status = './rrd/status.rrd';
# my $rrd_extra = './rrd/extra.rrd';


our (%config, %selectors, %config_by_tag );
our ($desc_url, $data_url);
our %credentials;
our ( @js_index, %js_rev_index);
require ('./config.pm');


my $filename = shift  @ARGV or die "usage: $0 filename-log";

open (my $FILE, '<', $filename) or die "cannot read from $filename";
open (my $STATUS, '>>', $status_log) or die "cannot write to $status_log";


# i want to learn about status behaviour
my $last_status ='';
my %status_analyzer;

while (<$FILE>) {
	# my ($dt, $vals) = $_ =~   /^\[(.*)\];\[(.*)\]$/ ;
	my ($dt, $vals) = $_ =~   /^\[(.*)\];(\[.*\])$/ ;
	
	#  date -d'2020-12-31 23:05:02+00:00' +%s
	my $unixtime = `date -d'$dt' +%s`;
	chomp $unixtime;
	
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

	my @taglist = @{$selectors{ status }} ;

	# cycle over selected value pairs
	my $status_string ;
	for my $tag (@taglist) {
		my $val = $tv{  $tag } ;
		# printf "%s :   %s  ->  %s  \n", $dt, $tag , $val;

		# keep status changer tag
		my $status_tag = sprintf "%s-%s", $tag , $val;

		# keep status statistics
		unless ( defined $status_analyzer{ $status_tag } )  {
			$status_analyzer{ $status_tag }->{ first  } = $dt;
		}
		$status_analyzer{ $status_tag }->{ last  } = $dt;
		$status_analyzer{ $status_tag }->{ count  }++;

		# keep skd of cononical status tag
		$status_string .= sprintf (":%s->%s" , $tag , $val);
	}

	# if status changed.... log and memorize
	if ($status_string ne $last_status ) {
 		

		my $logstring = sprintf "%s : new status:  %s  ", $dt, $status_string;
		print $logstring, "\n";
		print $STATUS $logstring, "\n";

		$last_status = $status_string ;
		# system ("echo $logstring >> $status_log")  ;
		# status_log ....
	}


	# my $rrd_template = join (':', @taglist);
	# print $rrd_template , "\n";

	# my @rrd_values = map { $tv{ $_ }   } @taglist;
	# my $rrd_values = join (':', $unixtime  , @rrd_values);
	# print $rrd_values , "\n";

	# RRDs::update($rrd_temps, '--template', $rrd_template, $rrd_values);
	# if ( RRDs::error ) {
	# 	printf STDERR ( "error updating RRD %s: %s \n", $rrd_temps , RRDs::error ) ;
	# 	# die "rrd update error";
	# }

	# die "========================== DEBUG ==========================";

}

print Dumper ( %status_analyzer );

close $FILE;
close $STATUS;

