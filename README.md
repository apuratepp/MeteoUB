MeteoUB
=======
Classe per al tractament de les dades meteorològiques a la Facultat de Física de la Universitat de Barcelona, a la Zona Universitària.

* URL original de les dades: [http://infomet.am.ub.es/campbell/www.dat](http://infomet.am.ub.es/campbell/www.dat)
* URL original de temperatures extremes [http://infomet.am.ub.edu/campbell/maxmin.dat](http://infomet.am.ub.edu/campbell/maxmin.dat)
* en format JSON: [meteo.json](http://ulisses.fis.ub.edu:8001/services/meteo/meteo.json)
* en format XML: [meteo.xml](http://ulisses.fis.ub.edu:8001/services/meteo/meteo.xml)

Utilització
-----------

```ruby
require 'meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => "tmp/www.dat"
puts meteo.temperature	# => 14.4
p meteo.dades # => {:datetime=>#<DateTime: 117884401/48,0,2299161>, :status=>"OK", :precipitation=>0.0, :pressure=>1027.0, :temperature=>14.4, :humidity=>54.0, :max_wind_speed=>4.4, :sunrise=>#<DateTime: 1768265861/720,0,2299161>, :wind_direction=>276.0, :sunset=>#<DateTime: 707306453/288,0,2299161>, :rain=>false}

```

Todo
----
* Twitter: respostes en funció de les mencions