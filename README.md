MeteoUB
=======
Classe per al tractament de les dades meteorològiques a la Facultat de Física de la Universitat de Barcelona, a la Zona Universitària.

* URL original de les dades: [www.dat](http://infomet.am.ub.es/campbell/www.dat)
* en format JSON: [meteo.json](http://ulisses.fis.ub.edu:8001/services/meteo/meteo.json)
* en format XML: [meteo.xml](http://ulisses.fis.ub.edu:8001/services/meteo/meteo.xml)

Utilització
-----------

```ruby
require 'meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => "tmp/www.dat"
puts meteo.temperature	# => 13.9
p meteo.dades # => {:pressure=>1027.0, :status=>"OK", :humidity=>54.0, :temperature=>14.2, :sunrise=>#<DateTime: 1768265861/720,0,2299161>, :wind_speed=>4.4, :sunset=>#<DateTime: 707306453/288,0,2299161>, :plou=>false, :datetime=>#<DateTime: 117884401/48,0,2299161>}

```

Todo
----
* Afegir més dades (direcció del vent, etc.)
* Twitter: respostes en funció de les mencions