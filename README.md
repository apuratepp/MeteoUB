MeteoUB
=======
Classe per al tractament de les dades meteorològiques a la Facultat de Física de la Universitat de Barcelona, a la Zona Universitària.

* URL original de les dades: [http://infomet.am.ub.es/campbell/www.dat](http://infomet.am.ub.es/campbell/www.dat)
* URL original de temperatures extremes [http://infomet.am.ub.edu/campbell/maxmin.dat](http://infomet.am.ub.edu/campbell/maxmin.dat)
* URL original de les dades de pluja [http://infomet.am.ub.es/metdata/plu.dat](http://infomet.am.ub.es/metdata/plu.dat)

* en format JSON: [meteo.json](http://ulisses.fis.ub.edu:8001/services/meteo/meteo.json)
* en format XML: [meteo.xml](http://ulisses.fis.ub.edu:8001/services/meteo/meteo.xml)

Utilització
-----------

```ruby
require 'meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => "tmp/www.dat"
puts meteo.temperature	# => 14.4
p meteo.dades # => {:temperature_max=>{:datetime=>#<DateTime: 88414853/36,0,2299161>, :temperature=>11.3}, :datetime=>#<DateTime: 117886531/48,0,2299161>, :status=>"OK", :max_wind_speed=>7.4, :temperature_min=>{:datetime=>#<DateTime: 353659495/144,0,2299161>, :temperature=>3.3}, :pressure=>1019.5, :temperature=>5.8, :humidity=>59.0, :wind_direction=>138.0, :sunrise=>#<DateTime: 1178865019/480,0,2299161>, :windrose=>"SE", :sunset=>#<DateTime: 1768297837/720,0,2299161>, :precipitation=>0.0, :rain=>false}

```

Todo
----
* Twitter: respostes en funció de les mencions