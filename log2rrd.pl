#!/usr/bin/perl
# read config_plain.pm and output debug and devel info
# run after every config change

use warnings;
use strict;


use Data::Dumper::Simple;
use LWP::Simple;

my $debug = 3;

my $file_tpl = '/home/wrosner/guntamatic/rrd/%s.rrd';

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
print Dumper  (@values) if ($debug >=5 ) ;

# build tag - value list 
my %tv;

for my $i (0 .. $#values) {
	my $val = $values[  $i ] ;
	my $id = $js_index[ $i ] ;
		# use only configured values
	my $tag = $config{ $id }->{ tag } ;
	next unless defined $tag ;
		### printf "\t ID=%03d, tag=%s,       \t value=%s  \n", $id,  $tag,  $val;

	$tv{$tag} = numbrify ( $val);
}

print Dumper  (%tv) if ($debug >=3 ) ;


for my $rrd ( sort keys %RRD_list) {
	my $do_stat = $RRD_list{ $rrd }->{ stat } ;
	unless (defined $do_stat) { die "config error - missing stat in rrd $rrd " } ;

	my $rrdfile = sprintf $file_tpl, $rrd ;

	my @taglist = @{$selectors{ $rrd }} ;
	unless (@taglist) { die "config error - missing selectors for rrd $rrd " } ;
	
	my $rrd_template = join (':', @taglist);

	unless ( -f $rrdfile ) {
		printf STDERR "cannot find %s - skipping... \n", $rrdfile ;
		next;
	}
        if ($debug >=3 ) {
                printf "updating %s, stat=%d, fields: \n\t%s \n", $rrdfile , $do_stat, $rrd_template;
        } 

}
