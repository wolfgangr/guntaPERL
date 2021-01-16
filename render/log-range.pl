#!/usr/bin/perl -w
use strict ;
use warnings ;

use CGI qw/:standard/;
# use Scalar::Util qw(looks_like_number);

my $start =  param('start');
my $num = param('num');
my $log = './status.log';

# e'); drop all tables;-- is nice guy...
# DEBUG ("start: illegal param format") unless (looks_like_number ( $start));
# DEBUG ("num: illegal param format") unless (looks_like_number ( $num));
# spritf and %d do a good job

# tail -n+$2 $1 | head -n$3
my $cmd = sprintf "tail -n+%d %s | head -n%d", $start, $log , $num;


print header();
print start_html(-title => 'variable test mit perl CGI');
print h1('so what');

print "<pre>";
# printf "start=%s;<br>\n", $start;
# printf "num=%s;<br>\n", $num;
# printf "cmd=%s;<br>\n", $cmd;

print `$cmd`;
print "</pre>";

# printf "end=%s;\n", param('end');


print end_html();

exit;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# debug with continued laoding
sub debug {
  my $in = shift;	
  print
    "\n<pre><code>\n",
    $in,  
    "\</code></pre>\n",
  ;
}


# final die like debug
sub DEBUG {
    my $in = shift;	
    print header;
    print start_html('### DEBUG ###');
    debug ( $in) ;
    print end_html;
  ;
  exit; # is it bad habit to exit from a sum??
}

