#!/usr/bin/perl
use strict;
use warnings;
use CGI qw/:standard/;
use Data::Dumper ;
use Storable ();
use Time::Piece;
use File::stat;


# our $dtformat = '+\'%d.%m.%Y %T\'' ; # datetime format string for console `date`
# our $RRDdtf = "+\'%d.%m.%Y %H:%M\'" ; # RRD does not like seconds here 

my $statusfile = '../rrd/tv_export.storable';

# ~~~~ local config stuff 

our (%config, %selectors, %config_by_tag );
# our ($desc_url, $data_url);
# our %credentials;
require ('../config_plain.pm');

# require ('./library.pm');

# ~~~~~ end of config, start processing






my $f_st = stat($statusfile) or die "No $statusfile: $!";
my $sf_modified = $f_st->mtime ;

my $tp_modified =  Time::Piece->new($sf_modified);
my $hr_modified = $tp_modified->ymd . ' - ' . $tp_modified->hms;

my $tv_p = Storable::lock_retrieve( $statusfile );
my %tv = %$tv_p ;





# ~~~~~ end of processing, start HTML rendering ~~~~~~~~~~~~~~~

print header();
print start_html(-title => 'Testpage No2');
print h1('Test 2');

debug (\%tv, $sf_modified, $tp_modified , $hr_modified) ;

print end_html();

exit ;

#~~~~ subs below ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# debug with continued laoding
sub debug {
  print
    "\n<pre><code>\n",
    Dumper ( @_),
    "\</code></pre>\n",
  ;
}

# final die like debug
sub DEBUG {
    print header,
    start_html('### DEBUG ###'),
    debug ( @_) ,
    end_html
  ;
  exit; # is it bad habit to exit from a sum??
}


