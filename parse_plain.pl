#!/usr/bin/perl
# try to parse daqdesc.cgi from guntamatic heater old api under /, not under /ext/
# this one speaks plain text, line separated, and has some more items than the /ext/-JSON
#

use Data::Dumper;
use JSON;
use Data::Dumper::Simple;
use LWP::Simple;
# use Data::Dumper;


our (%config, %selectors, %config_by_tag );
# our ($desc_url, $data_url);
# our %credentials;
# our ( @js_index, %js_rev_index);
our ($desc_url_plain, $data_url_plain, $desc_url_json, $data_url_json;
require ('./config.pm');

printf "%s\n" , $desc_url_plaini ;
printf "%s\n" , $data_url_plain ;
printf "%s\n" , $desc_url_json ;
printf "%s\n" , $data_url_json ;

