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
# - add mnemnonic tags as 'tag' fields
# - add qw ( some sorted and selected tags) as extraction filters
# - test



our %config =  ( 
  '3' => {
           'type' => 'float',
           'id' => 3,
           'unit' => "\x{c2}\x{b0}C",
           'name' => 'Kesseltemperatur'
         },
  '17' => {
            'unit' => '%',
            'id' => 17,
            'name' => 'Pufferladung',
            'type' => 'integer'
          },
  '18' => {
            'name' => 'CO2 Gehalt',
            'unit' => '%',
            'id' => 18,
            'type' => 'float'
          },
  '20' => {
            'id' => 20,
            'unit' => undef,
            'name' => 'Betriebscode',
            'type' => 'integer'
          },
  '23' => {
            'type' => 'float',
            'id' => 23,
            'unit' => "\x{c2}\x{b0}C",
            'name' => 'Aussentemperatur'
          },
  '24' => {
            'type' => 'float',
            'id' => 24,
            'unit' => "\x{c2}\x{b0}C",
            'name' => 'Puffer oben'
          },
  '25' => {
            'type' => 'float',
            'name' => 'Puffer unten',
            'id' => 25,
            'unit' => "\x{c2}\x{b0}C"
          },
  '26' => {
            'type' => 'boolean',
            'id' => 26,
            'unit' => undef,
            'name' => 'Pumpe HP0'
          },
  '27' => {
            'type' => 'float',
            'unit' => "\x{c2}\x{b0}C",
            'id' => 27,
            'name' => 'Warmwasser 0'
          },
  '28' => {
            'id' => 28,
            'unit' => undef,
            'name' => 'P Warmwasser 0',
            'type' => 'boolean'
          },
  '35' => {
            'type' => 'float',
            'name' => 'Raumtemp. HK 1',
            'id' => 35,
            'unit' => "\x{c2}\x{b0}C"
          },
  '37' => {
            'id' => 37,
            'unit' => "\x{c2}\x{b0}C",
            'name' => 'Vorlauf Ist 1',
            'type' => 'float'
          },
  '38' => {
            'name' => 'Pumpe HK 1',
            'unit' => undef,
            'id' => 38,
            'type' => 'boolean'
          },
  '40' => {
            'type' => 'float',
            'id' => 40,
            'unit' => "\x{c2}\x{b0}C",
            'name' => 'Raumtemp. HK 2'
          },
  '42' => {
            'name' => 'Vorlauf Ist 2',
            'unit' => "\x{c2}\x{b0}C",
            'id' => 42,
            'type' => 'float'
          },
  '43' => {
            'id' => 43,
            'unit' => undef,
            'name' => 'Pumpe HK 2',
            'type' => 'boolean'
          },
  '77' => {
            'type' => 'boolean',
            'id' => 77,
            'unit' => undef,
            'name' => 'Kesselfreigabe'
          },
  '78' => {
            'type' => 'string',
            'id' => 78,
            'unit' => undef,
            'name' => 'Betrieb'
          },
  '79' => {
            'type' => 'string',
            'name' => 'Programm',
            'unit' => undef,
            'id' => 79
          },
  '81' => {
            'type' => 'string',
            'id' => 81,
            'unit' => undef,
            'name' => 'Progamm HK1'
          },
  '82' => {
            'type' => 'string',
            'name' => 'Progamm HK2',
            'unit' => undef,
            'id' => 82
          },
  '95' => {
            'name' => 'Leistung',
            'unit' => '%',
            'id' => 95,
            'type' => 'float'
          },
  '104' => {
             'id' => 104,
             'unit' => undef,
             'name' => 'Serial',
             'type' => 'integer'
           },
  '106' => {
             'name' => 'Betriebszeit',
             'unit' => 'h',
             'id' => 106,
             'type' => 'integer'
           },
  '107' => {
             'name' => 'Servicezeit',
             'unit' => 'd',
             'id' => 107,
             'type' => 'integer'
           },
  '108' => {
             'unit' => 'h',
             'id' => 108,
             'name' => 'Asche leeren in',
             'type' => 'integer'
           }

);	   

1;
