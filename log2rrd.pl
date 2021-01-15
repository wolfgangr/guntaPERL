#!/usr/bin/perl
# read config_plain.pm and output debug and devel info
# run after every config change

use warnings;
use strict;


use Data::Dumper::Simple ;
# use LWP::Simple;
use RRDs() ;
# use Cwd  qw (realpath);
# use File::Glob ':bsd_glob';
use Storable ();


my $debug = 3;

my $interval = 60 ; # run every ... seconds - align with rrd step!
my $interval_offset = 23 ; # + offset for retrieveal

my $homedir = `echo ~`;
chomp $homedir ;

# my $username = `echo \$USER` ;
my @passdw = getpwuid($<);
my $username = $passdw[0];

my $file_tpl =  $homedir .  '/guntamatic/rrd/%s.rrd' ;
my $status_cache =  $homedir . '/guntamatic/rrd/last_status.pls' ; # keep status between invocations, as string
my $tv_exporter =  $homedir . '/guntamatic/rrd/tv_export.storable' ; # keep %tv hash for consumers, use "perl Storable"
my $status_logfile = sprintf '/var/log/%s/guntamatic_status.log', $username  ; 


our (%config,  %config_by_tag );
our ($desc_url, $data_url);
our (%RRD_list,  %selectors);
# our %credentials;
require ('./config_plain.pm');

require ('./library.pm');

if ($debug >=5 ) {
	print Dumper (%config) ;  
	print Dumper (	$desc_url,  $data_url);
	print Dumper ( %config_by_tag) ;
	print Dumper (%RRD_list,  %selectors);
}


# cheap conversion to infinite loop

my $lastrun = time();

BEGIN_OF_MAIN_LOOP:

my @values = retrieve ( $data_url) or die " cannot retrieve boiler data $data_url";
my $timestamp = time();
$timestamp -=   $timestamp %  $interval;   # log at rrd interval boarders to avoid PDP rounding

print Dumper  (@values) if ($debug >=5 ) ;

# build tag - value list 
my %tv;

for my $i (0 .. $#values) {
	my $val = $values[  $i ] ;
	my $conf_itm = $config{ $i }   ;
	next unless defined $conf_itm;
		# use only configured values
	my $tag = $conf_itm->{ tag } ;
	next unless defined $tag ;
		### printf "\t ID=%03d, tag=%s,       \t value=%s  \n", $id,  $tag,  $val;

	$val = numbrify ( $val, $conf_itm );
	$val= 'U' unless defined $val;
	$tv{$tag} = $val;
}

print Dumper  (%tv) if ($debug >=5 ) ;

my $status =  ''; #  $timestamp . ':';

for my $rrd ( sort keys %RRD_list) {
	print "\n" if ($debug >=3 );

	my $do_stat = $RRD_list{ $rrd }->{ stat } ;
	unless (defined $do_stat) { die "config error - missing stat in rrd $rrd " } ;

	# build and check file name
	# my $rel_path =  (sprintf $file_tpl, $rrd ) ;
	# my $rrdfile =  bsd_glob ( $rel_path,  GLOB_TILDE );
	my $rrdfile = (sprintf $file_tpl, $rrd ) ;

	# printf( " tpl %s, rrd %s, sprintf %s, ", $file_tpl, $rrd , $rel_path   );
	# printf( " real: %s \n", $rrdfile );
	
	# unless ( -f $rrdfile ) {
	if ( 0 ) {
                printf STDERR "cannot find %s - skipping... \n", $rrdfile ;
		next;
        }

	# build  tag list
	my @taglist = @{$selectors{ $rrd }} ;
	unless (@taglist) { die "config error - missing selectors for rrd $rrd " } ;
	
	my $rrd_template = join (':', @taglist);

        # build  value list
        my @rrd_values = map { $tv{ $_ }   } @taglist;
        my $rrd_valstr = join (':', ($timestamp  , @rrd_values) );

	
        if ($debug >=3 ) {
                printf "updating %s, stat=%d \n", $rrdfile , $do_stat;
		printf " - fields: %s \n",  $rrd_template;
		printf " - values: %s \n", $rrd_valstr;
        } 

	next unless ( -f $rrdfile );
	RRDs::update($rrdfile, '--template', $rrd_template, $rrd_valstr);
	if ( RRDs::error ) {
		printf STDERR ( "error updating RRD %s: %s \n", $rrdfile , RRDs::error ) ;
		# die "rrd update error";
	} elsif ($debug >=3 ) {
		printf ( "\tsuccess updating RRD %s:  \n", $rrdfile );
	}

	#print "\n" if ($debug >=3 );

	if ( $do_stat ) {
		for my  $i ( 0 .. $#taglist) {
			$status .= ':' . $taglist[$i] . ':' .   $rrd_values[$i ]; 
		}
	}
}
# rrd writing done
#
# check for satus change
printf "\nstatus  string:%s\n cache= %s , logfile= %s , \n",  $status, $status_cache, $status_logfile;
# my $oldstate= Storable::retrieve ($status_cache) if (-e $status_cache) ;
my $oldstate= `cat $status_cache`  if (-e $status_cache) ;
chomp $oldstate;

unless ( $oldstate eq $status) {
	print "status changed\n ";
	# system ( "echo '$status' > $status_cache");	
	my $hrdate = `date`;
	chomp $hrdate;
	my $logline = $hrdate;
	$logline .= ':' . $timestamp . ':' ;
	$logline .= $status;
	system ( "echo '$logline' >> $status_logfile "); 
} else {
	print "status unchanged\n ";
}
system ( "echo '$status' > $status_cache");

# ~~~~~~~~~~ export 

Storable::lock_store \%tv, $tv_exporter ;

# ~~~~~~~~~~~ end of work,  ~~~~~~~~~~

# interval timer

my $now = time()  ; 
my $modulo = ($now - $interval_offset) % $interval ;
my $nextrun = $now + $interval - $modulo ;

my $sleeptime = $nextrun  - $now ;

printf "timestamp: %d, iterator - last run: %d, now: %d, modulo %d, next run: %d, sleep: %d\n", 
	$timestamp, $lastrun, $now, $modulo ,  $nextrun , $sleeptime ;

$lastrun = $now ;  # just for debugging

if ($sleeptime >0) {  sleep $sleeptime ; }


# sleep 55;
goto BEGIN_OF_MAIN_LOOP ;

