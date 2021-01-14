# data usage configruation file
# 	for plain api in /
# 	in contrast to the json api in /ext/

# tags of rrd, will be used to create filenames,
# if { stat => 1 } , we might do a status change log
#
our %RRD_list = ( 
       	temps    => { stat => 1 } ,
	status   => { stat => 0 } ,
	tempsX   => { stat => 1 } ,
	statusX  => { stat => 0 } ,
) ;

our %selectors = (
  json =>    [ qw (T_cald pc_buf CO2 S_op T_out T_buf_top T_buf_bot 
  		SP_buf0 T_hw0 SP_hw0 T_r1 T_P1 S_P1 T_r2 T_P2 S_P2 
		enbl opmode prog_main prog_HK1 prog_HK2 pc_pwr 
		serial op_hr srv_d deash_h) ],
  plain_xtra => [ qw (  pc_exh  pc_vent pc_stok I_stok pc_aug1 I_aug1 
	  	pc_grt frflp level stb tks1 fault0 fault1 ver 
		T_ret pc_aug2 I_aug2 ign_vnt ign_ht ) ],
  test =>     [ qw (T_cald T_buf_top deash_h) ],
  temps  =>   [ qw( pc_buf pc_pwr CO2 T_cald T_hw0 T_buf_top T_buf_bot T_out T_P1 T_P2 ) ],
  status =>   [ qw( prog_main prog_HK1 prog_HK2 enbl opmode S_op SP_buf0 SP_hw0 S_P1 S_P2 op_hr) ],
  tempsX =>   [ qw(	T_ret pc_exh  pc_vent pc_stok I_stok pc_aug1 I_aug1 pc_grt ) ],
  statusX =>  [ qw(  fault0 fault1 frflp level stb tks1 ign_vnt ign_ht  ) ],
  service =>  [ qw( serial op_hr srv_d deash_h) ],
) ;

my @enum_prog_HK = qw ( AUS NORMAL HEIZEN NACHLAUF ABSENKEN ) , 'ABSENKEN BIS...'   ;
my @enum_prog_main = qw ( AUS NORMAL WARMWASSER HEIZEN ABSENKEN ) , 'ABSENKEN BIS', 'WW Nachl.' , qw( ROSTREIN. HANDBETRIEB  ) ;
my @enum_opmode = qw ( AUS START ZÜNDUNG REGELUNG NACHLAUF    ) ;
our @enum_boolean = qw ( AUS EIN ) ;


our %config =  ( 
  '3' => {
           'type' => 'float',
           'name' => 'Kesseltemperatur',
           'id' => 3,
           'tag' => 'T_cald',
           'unit' => '°C',
           'JSON' => 1
         },
  '4' => {
	  tag => 'pc_exh', 
           'id' => 4,
           'name' => 'Rauchgasauslastung',
           'unit' => '%'
         },
  '7' => {
	  tag => 'pc_vent',
           'name' => 'Saugzuggebläse',
           'id' => 7,
           'unit' => '%'
         },
  '8' => {
	  tag => 'pc_stok',
           'unit' => '%',
           'id' => 8,
           'name' => 'Stoker'
         },
  '9' => {
	  tag => 'I_stok',
           'unit' => 'A',
           'name' => 'I stock.',
           'id' => 9
         },
  '10' => {
            'id' => 10,
            'name' => 'Puffer T5',
            'JSON' => 0,
            'unit' => '°C'
          },
  '11' => {
	  tag => 'pc_aug1',
            'unit' => '%',
            'name' => 'Austragung: 1',
            'id' => 11
          },
  '12' => {
	  tag => 'I_aug1',
            'name' => 'I Austragung 1',
            'id' => 12,
            'unit' => 'A'
          },
  '13' => {
            'JSON' => 0,
            'unit' => '°C',
            'name' => 'Puffer T6',
            'id' => 13
          },
  '15' => {
            'JSON' => 0,
            'unit' => '°C',
            'name' => 'Puffer T7',
            'id' => 15
          },
  '16' => {
	  tag => 'pc_grt',
            'id' => 16,
            'name' => 'Rost',
            'unit' => '%'
          },
  '17' => {
            'JSON' => 1,
            'unit' => '%',
            'id' => 17,
            'tag' => 'pc_buf',
            'type' => 'integer',
            'name' => 'Pufferladung'
          },
  '18' => {
            'id' => 18,
            'tag' => 'CO2',
            'type' => 'float',
            'name' => 'CO2 Gehalt',
            'unit' => '%',
            'JSON' => 1
          },
  '20' => {
            'unit' => undef,
            'JSON' => 1,
            'id' => 20,
            'tag' => 'S_op',
            'type' => 'integer',
            'name' => 'Betriebscode'
          },
  '22' => {
            'id' => 22,
            'name' => 'Vorlauf Ist 0',
            'JSON' => 0,
            'unit' => '°C'
          },
  '23' => {
            'type' => 'float',
            'name' => 'Aussentemperatur',
            'id' => 23,
            'tag' => 'T_out',
            'JSON' => 1,
            'unit' => '°C'
          },
  '24' => {
            'JSON' => 1,
            'unit' => '°C',
            'name' => 'Puffer oben',
            'type' => 'float',
            'tag' => 'T_buf_top',
            'id' => 24
          },
  '25' => {
            'unit' => '°C',
            'JSON' => 1,
            'name' => 'Puffer unten',
            'type' => 'float',
            'tag' => 'T_buf_bot',
            'id' => 25
          },
  '26' => {
            'name' => 'Pumpe HP0',
            'type' => 'boolean',
            'tag' => 'SP_buf0',
            'id' => 26,
            'unit' => undef,
            'JSON' => 1
          },
  '27' => {
            'unit' => '°C',
            'JSON' => 1,
            'id' => 27,
            'tag' => 'T_hw0',
            'type' => 'float',
            'name' => 'Warmwasser 0'
          },
  '28' => {
            'tag' => 'SP_hw0',
            'id' => 28,
            'name' => 'P Warmwasser 0',
            'type' => 'boolean',
            'JSON' => 1,
            'unit' => undef
          },
  '29' => {
            'name' => 'Warmwasser 1',
            'id' => 29,
            'JSON' => 0,
            'unit' => '°C'
          },
  '30' => {
            'name' => 'P Warmwasser 1',
            'id' => 30,
            'unit' => '',
            'JSON' => 0
          },
  '31' => {
            'JSON' => 0,
            'unit' => '°C',
            'name' => 'Warmwasser 2',
            'id' => 31
          },
  '32' => {
            'unit' => '',
            'JSON' => 0,
            'id' => 32,
            'name' => 'P Warmwasser 2'
          },
  '33' => {
            'JSON' => 0,
            'unit' => '°C',
            'name' => 'Raumtemp. HK 0',
            'id' => 33
          },
  '34' => {
            'name' => 'Pumpe HK 0',
            'id' => 34,
            'JSON' => 0,
            'unit' => ''
          },
  '35' => {
            'JSON' => 1,
            'unit' => '°C',
            'id' => 35,
            'tag' => 'T_r1',
            'type' => 'float',
            'name' => 'Raumtemp. HK 1'
          },
  '37' => {
            'unit' => '°C',
            'JSON' => 1,
            'id' => 37,
            'tag' => 'T_P1',
            'type' => 'float',
            'name' => 'Vorlauf Ist 1'
          },
  '38' => {
            'JSON' => 1,
            'unit' => undef,
            'name' => 'Pumpe HK 1',
            'type' => 'boolean',
            'tag' => 'S_P1',
            'id' => 38
          },
  '40' => {
            'unit' => '°C',
            'JSON' => 1,
            'type' => 'float',
            'name' => 'Raumtemp. HK 2',
            'id' => 40,
            'tag' => 'T_r2'
          },
  '42' => {
            'type' => 'float',
            'name' => 'Vorlauf Ist 2',
            'id' => 42,
            'tag' => 'T_P2',
            'JSON' => 1,
            'unit' => '°C'
          },
  '43' => {
            'JSON' => 1,
            'unit' => undef,
            'type' => 'boolean',
            'name' => 'Pumpe HK 2',
            'id' => 43,
            'tag' => 'S_P2'
          },
  '45' => {
            'JSON' => 0,
            'unit' => '°C',
            'name' => 'Raumtemp. HK 3',
            'id' => 45
          },
  '46' => {
            'name' => 'Pumpe HK 3',
            'id' => 46,
            'unit' => '',
            'JSON' => 0
          },
  '47' => {
            'unit' => '°C',
            'JSON' => 0,
            'name' => 'Raumtemp. HK 4',
            'id' => 47
          },
  '49' => {
            'unit' => '°C',
            'JSON' => 0,
            'id' => 49,
            'name' => 'Vorlauf Ist 4'
          },
  '50' => {
            'unit' => '',
            'JSON' => 0,
            'name' => 'Pumpe HK 4',
            'id' => 50
          },
  '52' => {
            'name' => 'Raumtemp. HK 5',
            'id' => 52,
            'unit' => '°C',
            'JSON' => 0
          },
  '54' => {
            'JSON' => 0,
            'unit' => '°C',
            'name' => 'Vorlauf Ist 5',
            'id' => 54
          },
  '55' => {
            'name' => 'Pumpe HK 5',
            'id' => 55,
            'JSON' => 0,
            'unit' => ''
          },
  '57' => {
            'unit' => '°C',
            'JSON' => 0,
            'name' => 'Raumtemp. HK 6',
            'id' => 57
          },
  '58' => {
            'unit' => '',
            'JSON' => 0,
            'name' => 'Pumpe HK 6',
            'id' => 58
          },
  '59' => {
            'unit' => '°C',
            'JSON' => 0,
            'name' => 'Raumtemp. HK 7',
            'id' => 59
          },
  '61' => {
            'unit' => '°C',
            'JSON' => 0,
            'id' => 61,
            'name' => 'Vorlauf Ist 7'
          },
  '62' => {
            'id' => 62,
            'name' => 'Pumpe HK 7',
            'unit' => '',
            'JSON' => 0
          },
  '64' => {
            'unit' => '°C',
            'JSON' => 0,
            'name' => 'Raumtemp. HK 8',
            'id' => 64
          },
  '66' => {
            'unit' => '°C',
            'JSON' => 0,
            'id' => 66,
            'name' => 'Vorlauf Ist 8'
          },
  '67' => {
            'JSON' => 0,
            'unit' => '',
            'name' => 'Pumpe HK 8',
            'id' => 67
          },
  '70' => {
	  tag => 'frflp',
	  type => 'boolean',
            'unit' => '',
            'id' => 70,
            'name' => 'Brandschutzklappe'
          },
  '71' => {
            'JSON' => 0,
            'unit' => '°C',
            'id' => 71,
            'name' => 'Vorlauf Ist 3'
          },
  '73' => {
            'name' => 'Vorlauf Ist 6',
            'id' => 73,
            'JSON' => 0,
            'unit' => '°C'
          },
  '74' => {
	  tag => 'level',
	  type => 'boolean',
            'unit' => '',
            'name' => 'Füllstand',
            'id' => 74
          },
  '75' => {
	  tag => 'stb',
	  type => 'boolean',
            'unit' => '',
            'name' => 'STB',
            'id' => 75
          },
  '76' => {
	  tag => 'tks1',
	  type => 'boolean',
            'name' => 'TKS 1',
            'id' => 76,
            'unit' => ''
          },
  '77' => {
            'type' => 'boolean',
            'name' => 'Kesselfreigabe',
            'id' => 77,
            'tag' => 'enbl',
            'unit' => undef,
            'JSON' => 1
          },
  '78' => {
            'id' => 78,
            'tag' => 'opmode',
            'type' => 'string',
	    'enum' => [ @enum_opmode  ] ,
            'name' => 'Betrieb',
            'unit' => undef,
            'JSON' => 1
          },
  '79' => {
            'unit' => undef,
            'JSON' => 1,
            'name' => 'Programm',
            'type' => 'string',
	    'enum' => [ @enum_prog_main  ] ,
            'tag' => 'prog_main',
            'id' => 79
          },
  '80' => {
            'name' => 'Progamm HK0',
            'id' => 80,
            'JSON' => 0,
            'unit' => ''
          },
  '81' => {
            'name' => 'Progamm HK1',
            'type' => 'string',
	    'enum' => [ @enum_prog_HK ] ,
            'tag' => 'prog_HK1',
            'id' => 81,
            'unit' => undef,
            'JSON' => 1
          },
  '82' => {
            'tag' => 'prog_HK2',
            'id' => 82,
            'name' => 'Progamm HK2',
            'type' => 'string',
	    'enum' => [ @enum_prog_HK ] ,
            'JSON' => 1,
            'unit' => undef
          },
  '83' => {
            'name' => 'Progamm HK3',
            'id' => 83,
            'JSON' => 0,
            'unit' => ''
          },
  '84' => {
            'id' => 84,
            'name' => 'Progamm HK4',
            'unit' => '',
            'JSON' => 0
          },
  '85' => {
            'JSON' => 0,
            'unit' => '',
            'name' => 'Progamm HK5',
            'id' => 85
          },
  '86' => {
            'unit' => '',
            'JSON' => 0,
            'name' => 'Progamm HK6',
            'id' => 86
          },
  '87' => {
            'name' => 'Progamm HK7',
            'id' => 87,
            'JSON' => 0,
            'unit' => ''
          },
  '88' => {
            'id' => 88,
            'name' => 'Progamm HK8',
            'unit' => '',
            'JSON' => 0
          },
  '89' => {
            'unit' => '°C',
            'JSON' => 0,
            'id' => 89,
            'name' => 'Puffer oben 0'
          },
  '90' => {
            'JSON' => 0,
            'unit' => '°C',
            'name' => 'Puffer unten 0',
            'id' => 90
          },
  '91' => {
            'unit' => '°C',
            'JSON' => 0,
            'id' => 91,
            'name' => 'Puffer oben 1'
          },
  '92' => {
            'JSON' => 0,
            'unit' => '°C',
            'id' => 92,
            'name' => 'Puffer unten 1'
          },
  '93' => {
            'name' => 'Puffer oben 2',
            'id' => 93,
            'JSON' => 0,
            'unit' => '°C'
          },
  '94' => {
            'id' => 94,
            'name' => 'Puffer unten 2',
            'JSON' => 0,
            'unit' => '°C'
          },
  '95' => {
            'tag' => 'pc_pwr',
            'id' => 95,
            'name' => 'Leistung',
            'type' => 'float',
            'JSON' => 1,
            'unit' => '%'
          },
  '96' => {
	  tag => 'fault0',
            'name' => 'Störung 0',
            'id' => 96,
            'unit' => ''
          },
  '97' => {
	  tag => 'fault1',
            'unit' => '',
            'id' => 97,
            'name' => 'Störung 1'
          },
  '98' => {
            'name' => 'Zusatzwarmw. 0',
            'id' => 98,
            'unit' => '°C',
            'JSON' => 0
          },
  '99' => {
            'JSON' => 0,
            'unit' => '',
            'name' => 'P Zusatzwarmw. 0',
            'id' => 99
          },
  '100' => {
             'JSON' => 0,
             'unit' => '°C',
             'name' => 'Zusatzwarmw. 1',
             'id' => 100
           },
  '101' => {
             'name' => 'P Zusatzwarmw. 1',
             'id' => 101,
             'unit' => '',
             'JSON' => 0
           },
  '102' => {
             'name' => 'Zusatzwarmw. 2',
             'id' => 102,
             'unit' => '°C',
             'JSON' => 0
           },
  '103' => {
             'JSON' => 0,
             'unit' => '',
             'id' => 103,
             'name' => 'P Zusatzwarmw. 2'
           },
  '104' => {
             'JSON' => 1,
             'unit' => undef,
             'type' => 'integer',
             'name' => 'Serial',
             'id' => 104,
             'tag' => 'serial'
           },
  '105' => {
	  tag => 'ver',
             'unit' => '',
             'id' => 105,
             'name' => 'Version'
           },
  '106' => {
             'JSON' => 1,
             'unit' => 'h',
             'type' => 'integer',
             'name' => 'Betriebszeit',
             'id' => 106,
             'tag' => 'op_hr'
           },
  '107' => {
             'unit' => 'd',
             'JSON' => 1,
             'name' => 'Servicezeit',
             'type' => 'integer',
             'tag' => 'srv_d',
             'id' => 107
           },
  '108' => {
             'unit' => 'h',
             'JSON' => 1,
             'tag' => 'deash_h',
             'id' => 108,
             'name' => 'Asche leeren in',
             'type' => 'integer'
           },
  '109' => {
             'name' => 'Fernpumpe 0',
             'id' => 109,
             'unit' => '',
             'JSON' => 0
           },
  '110' => {
             'name' => 'Fernpumpe 1',
             'id' => 110,
             'unit' => '',
             'JSON' => 0
           },
  '111' => {
             'name' => 'Fernpumpe 2',
             'id' => 111,
             'JSON' => 0,
             'unit' => ''
           },
  '112' => {
	  tag => 'T_ret',
             'unit' => '°C',
             'id' => 112,
             'name' => 'Rücklauftemp.'
           },
  '114' => {
	  tag => 'pc_aug2',
             'id' => 114,
             'name' => 'Austragung: 2',
             'unit' => '%'
           },
  '115' => {
	  tag => 'I_aug2',
             'id' => 115,
             'name' => 'I Austragung 2',
             'unit' => 'A'
           },
  '116' => {
             'name' => 'Brennstoffzähler',
             'id' => 116,
             'unit' => 'm3',
             'JSON' => 0
           },
  '117' => {
	  tag => 'ign_vnt',
	  'type' => 'boolean',
             'name' => 'Zündgebläse',
             'id' => 117,
             'unit' => ''
           },
  '118' => {
	  tag => 'ign_ht',
	  'type' => 'boolean',
             'id' => 118,
             'name' => 'Zündheizung',
             'unit' => ''
           }
   )
;


# reverse index
our %config_by_tag;
for  (keys  %config) {
	my $item_p = $config{ $_};
	my $tag = $item_p->{ tag } ;
	next unless defined $tag ;
	$config_by_tag{ $tag } = $item_p ;
}


our @plain_xtra_index = (4, 7, 8, 9, 11, 12, 16, 70, 74, 75, 76, 96, 97, 105, 112, 114, 115, 117, 118) ;


# sort helper
sub numeric_sort { $a <=> $b  }
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



our %credentials;
require ('./secret.pm');

my $urlator = sprintf "http://%s%%s?key=%s", $credentials{ host }, $credentials{ key } ;
# our $data_url_json = sprintf $urlator, '/ext/daqdata.cgi' ;
# our $desc_url_json = sprintf $urlator, '/ext/daqdesc.cgi' ;
our $data_url = my  $data_url_plain = sprintf $urlator, '/daqdata.cgi' ;
our $desc_url = my  $desc_url_plain = sprintf $urlator, '/daqdesc.cgi' ;



1;
	
