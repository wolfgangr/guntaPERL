#!/usr/bin/perl
use strict;
use warnings;
use CGI qw/:standard/;
use Data::Dumper ;
use Storable ();

our $dtformat = '+\'%d.%m.%Y %T\'' ; # datetime format string for console `date`
our $RRDdtf = "+\'%d.%m.%Y %H:%M\'" ; # RRD does not like seconds here 

my $statusfile = '../rrd/tv_export.storable';

my $tv_p = Storable::lock_retrieve( $statusfile );
my %tv = %$tv_p ;

print header();
print start_html(-title => 'Testpage No2');
print h1('Test 2');

debug (\%tv) ;

print end_html();

exit ;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

sub mydatetime {
  my $arg = shift;
  my $dtf = shift;
  $dtf = $dtformat unless $dtf ;
  my $rv =`date -d \@$arg $dtf` ;
  chomp $rv;
  return $rv ;
}

sub rrddatetime {
  my $arg = shift;
  return mydatetime ($arg , $RRDdtf) ;
}

