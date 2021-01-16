#!/usr/bin/perl
use strict;
use warnings;
use CGI qw/  :standard/;
use Data::Dumper ;
use Storable ();
use Time::Piece;
use File::stat;

# work around misconfiguration 
chdir '..' ; # omG ;-\


# our $dtformat = '+\'%d.%m.%Y %T\'' ; # datetime format string for console `date`
# our $RRDdtf = "+\'%d.%m.%Y %H:%M\'" ; # RRD does not like seconds here 

my $statusfile = './rrd/tv_export.storable';
my $title = "aktueller Status Guntamatic PowerChip";

# ~~~~ local config stuff 

our (%config, %selectors, %config_by_tag );
# our ($desc_url, $data_url);
# our %credentials;
require ('./config_plain.pm');

require ('./library.pm');

# ~~~~~ end of config, start processing






my $f_st = stat($statusfile) or die "No $statusfile: $!";
my $sf_modified = $f_st->mtime ;

my $tp_modified =  Time::Piece->new($sf_modified);
my $hr_modified = $tp_modified->ymd . ' - ' . $tp_modified->hms;

my $tv_p = Storable::lock_retrieve( $statusfile );
my %tv = %$tv_p ;

# my $printf_fmt = "id=%03d,  (   %10s   ) ,  %s %s , %s,   %s\n";

my $printf_fmt = "<td>%03d&nbsp;</td><th>&nbsp;%s&nbsp;</th><td>&nbsp;<b>%s</b>&nbsp;</td><td>%s</td>"
	#. "<td>foo</td>"
	. "<td>%s</td><td>&nbsp;%s</td>"
	. "<td>%s</td>" ;
	# . "</tr>\n";
my $th  = "<table><tr><th>ID</th><th>Kürzel</th><th>Wert</th><th>Einheit</th>"
#	. "<th>bar</th>"
	. "<th>Typ</th><th>Beschreibung</th>" 
	. "<th>Aufzählung</th>"
	. "</tr>\n";



# ~~~~~ end of processing, start HTML rendering ~~~~~~~~~~~~~~~

print header(  -type => "text/html", -charset => "UTF-8"   );
print start_html(-title => $title ,  -encoding => "UTF-8" );
print h3($title);


print "<hr>\n";
printf "Ladezeit: %s = %011d (unixtime) \n",  $hr_modified , $sf_modified  ;
print "<hr>\n";

print $th ;
for my $id (sort numeric_sort   keys %config) {
	my $tag = $config{ $id }->{ tag };
	next unless $tag;
	next unless defined  $tv{$tag};
	my $enums = 'nada';
	if ( defined (my $enum_p = $config{ $id }->{ enum } ) ) {
		$enums = '<font size="-2">' ;
		$enums .= join ( '<br>', @$enum_p ) ;
		$enums .= "<br>&nbsp;";
		$enums .= '</font>';
	}
	print '<tr valign="top">';
	print_config_item (  $tv{ $tag } , $config{ $id } , $printf_fmt   );
	printf "<td>%s</td></tr>\n", $enums ;

}
print "</table>\n";

debug ( [    \%tv, $sf_modified, $tp_modified , $hr_modified, \%config_by_tag , \%config ] ,
        , [ qw(  *tv *sf_modified  *tp_modified   *hr_modified  *config_by_tag    *config   ) ] )	;

print end_html();


exit ;

#~~~~ subs below ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# debug with continued laoding
sub debug {
  print
    "\n<pre><code>\n",
    Data::Dumper->Dump ( @_),
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


