# data usage configruation file
# where does it come from?
# - 'daqdesc.cgi?key=foobar' from boiler
# - convert json to perl hash
# - select only relevant data (manully, depends on boiler installation)
# - write sorted filtered hash aka 
# 	filtered_by_id.dump
# 
# where does it go to?
# - switch to full variable syntax
# - add mnemonic tags as 'tag' fields
# - add qw ( some sorted and selected tags) as extraction filters
# - test

our %selectors = (
  all => qw (T_cald pc_buf CO2 S_op T_out T_buf_top T_buf_bot 
  		SP_buf0 T_hw0 SP_hw0 T_r1 T_P1 S_P1 T_r2 T_P2 S_P2 
		enbl opmode prog_main prog_HK1 prog_HK2 pc_pwr 
		serial op_hr srv_d deash_h),
  test => qw (T_cald T_buf_top deash_h),
  rrd => qw( pc_buf pc_pwr CO2 T_cald T_hw0 T_buf_top T_buf_bot T_out T_P1 T_P2 ),
  status => qw( prog_main prog_HK1 prog_HK2 enbl opmode S_op SP_buf0 SP_hw0 S_P1 S_P2 ),
) ;

our %config =  ( 
  '3' => {
	  tag => 'T_cald',
           'type' => 'float',
           'id' => 3,
           'unit' => "\x{c2}\x{b0}C",
           'name' => 'Kesseltemperatur'
         },
  '17' => {
	  tag => 'pc_buf',	
	    'unit' => '%',
            'id' => 17,
            'name' => 'Pufferladung',
            'type' => 'integer'
          },
  '18' => {
	  tag =>  'CO2',
            'name' => 'CO2 Gehalt',
            'unit' => '%',
            'id' => 18,
            'type' => 'float'
          },
  '20' => {
	  tag => 'S_op',
            'id' => 20,
            'unit' => undef,
            'name' => 'Betriebscode',
            'type' => 'integer'
          },
  '23' => {
	  tag => 'T_out',
            'type' => 'float',
            'id' => 23,
            'unit' => "\x{c2}\x{b0}C",
            'name' => 'Aussentemperatur'
          },
  '24' => {
	  tag => 'T_buf_top',
            'type' => 'float',
            'id' => 24,
            'unit' => "\x{c2}\x{b0}C",
            'name' => 'Puffer oben'
          },
  '25' => {
	  tag => 'T_buf_bot',
            'type' => 'float',
            'name' => 'Puffer unten',
            'id' => 25,
            'unit' => "\x{c2}\x{b0}C"
          },
  '26' => {
	  tag => 'SP_buf0',
            'type' => 'boolean',
            'id' => 26,
            'unit' => undef,
            'name' => 'Pumpe HP0'
          },
  '27' => {
	  tag => 'T_hw0',
            'type' => 'float',
            'unit' => "\x{c2}\x{b0}C",
            'id' => 27,
            'name' => 'Warmwasser 0'
          },
  '28' => {
	  tag => 'SP_hw0',
            'id' => 28,
            'unit' => undef,
            'name' => 'P Warmwasser 0',
            'type' => 'boolean'
          },
  '35' => {
	  tag => 'T_r1',
            'type' => 'float',
            'name' => 'Raumtemp. HK 1',
            'id' => 35,
            'unit' => "\x{c2}\x{b0}C"
          },
  '37' => {
	  tag => 'T_P1',
            'id' => 37,
            'unit' => "\x{c2}\x{b0}C",
            'name' => 'Vorlauf Ist 1',
            'type' => 'float'
          },
  '38' => {
	  tag => 'S_P1',
            'name' => 'Pumpe HK 1',
            'unit' => undef,
            'id' => 38,
            'type' => 'boolean'
          },
  '40' => {
	  tag => 'T_r2',
            'type' => 'float',
            'id' => 40,
            'unit' => "\x{c2}\x{b0}C",
            'name' => 'Raumtemp. HK 2'
          },
  '42' => {
	  tag => 'T_P2',
            'name' => 'Vorlauf Ist 2',
            'unit' => "\x{c2}\x{b0}C",
            'id' => 42,
            'type' => 'float'
          },
  '43' => {
	  tag => 'S_P2',
            'id' => 43,
            'unit' => undef,
            'name' => 'Pumpe HK 2',
            'type' => 'boolean'
          },
  '77' => {
	  tag => 'enbl',
            'type' => 'boolean',
            'id' => 77,
            'unit' => undef,
            'name' => 'Kesselfreigabe'
          },
  '78' => {
	  tag => 'opmode',
            'type' => 'string',
            'id' => 78,
            'unit' => undef,
            'name' => 'Betrieb'
          },
  '79' => {
	  tag => 'prog_main',
            'type' => 'string',
            'name' => 'Programm',
            'unit' => undef,
            'id' => 79
          },
  '81' => {
	  tag => 'prog_HK1',
            'type' => 'string',
            'id' => 81,
            'unit' => undef,
            'name' => 'Progamm HK1'
          },
  '82' => {
	  tag => 'prog_HK2',
            'type' => 'string',
            'name' => 'Progamm HK2',
            'unit' => undef,
            'id' => 82
          },
  '95' => {
	  tag => 'pc_pwr',
            'name' => 'Leistung',
            'unit' => '%',
            'id' => 95,
            'type' => 'float'
          },
  '104' => {
	  tag => 'serial',
             'id' => 104,
             'unit' => undef,
             'name' => 'Serial',
             'type' => 'integer'
           },
  '106' => {
	  tag => 'op_hr',
             'name' => 'Betriebszeit',
             'unit' => 'h',
             'id' => 106,
             'type' => 'integer'
           },
  '107' => {
	  tag => 'srv_d',
             'name' => 'Servicezeit',
             'unit' => 'd',
             'id' => 107,
             'type' => 'integer'
           },
  '108' => {
	  tag => 'deash_h',
             'unit' => 'h',
             'id' => 108,
             'name' => 'Asche leeren in',
             'type' => 'integer'
           }

);	   


our %config_by_tag;

for  (keys  %config) {
	my $item_p = $config{ $_};
	my $tag = $item_p->{ tag } ;
	$config_by_tag{ $tag } = $item_p ;
}


# sort helper
sub numeric_sort { $a <=> $b  }
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



our %credentials;
require ('./secret.pm');

our $desc_url =  'http://' . $credentials{ host } ;
$desc_url .=  $credentials{ desc_api } ;
$desc_url .= '?key=' . $credentials{ key } ;

our $data_url =  'http://' . $credentials{ host } ;
$data_url .=  $credentials{ data_api } ;
$data_url .= '?key=' . $credentials{ key } ;





1;
