#!/usr/bin/perl -w
use strict ;
use warnings ;

use CGI qw/:standard/;
use Scalar::Util qw(looks_like_number);

# e'); drop all tables;-- is nice guy...
DEBUG ("start: illegal param format") unless (looks_like_number ( param('start')));
DEBUG ("num: illegal param format") unless (looks_like_number ( param('num')));


print header();
print start_html(-title => 'variable test mit perl CGI');
print h1('so what');

printf "start=%s;<br>\n", param('start');
printf "num=%s;<br>\n", param('num');
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

