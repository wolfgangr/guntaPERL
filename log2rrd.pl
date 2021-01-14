#!/usr/bin/perl
# read config_plain.pm and output debug and devel info
# run after every config change

use warnings;
use strict;


use Data::Dumper::Simple ;
# use LWP::Simple;
use RRDs() ;
# use Cwd  qw (realpath);
use File::Glob ':bsd_glob';

my $debug = 3;

# my $file_tpl = '/home/wrosner/guntamatic/rrd/%s.rrd';
my $file_tpl = '~/guntamatic/rrd/%s.rrd' ;
# $file_tpl = Cwd::realpath( '~/guntamatic/rrd/%s.rrd' );
# print $file_tpl;
# die "debug";

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


my @values = retrieve ( $data_url) or die " cannot retrieve boiler data $data_url";
my $timestamp = time();

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


for my $rrd ( sort keys %RRD_list) {
	print "\n" if ($debug >=3 );

	my $do_stat = $RRD_list{ $rrd }->{ stat } ;
	unless (defined $do_stat) { die "config error - missing stat in rrd $rrd " } ;

	# build and check file name
	my $rel_path =  (sprintf $file_tpl, $rrd ) ;
	# my $rrdfile = glob ($rel_path);
	my $rrdfile =  bsd_glob ( $rel_path,  GLOB_TILDE );

	printf( " tpl %s, rrd %s, sprintf %s, ", $file_tpl, $rrd , $rel_path   );
	printf( " real: %s \n", $rrdfile );
	# die "debug";
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


}
