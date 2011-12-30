MeteoUB
=======
Classe per al tractament de les dades meteorològiques a la Facultat de Física de la Universitat de Barcelona, a la Zona Universitària.
URL de les dades: [http://infomet.am.ub.es/campbell/www.dat](http://infomet.am.ub.es/campbell/www.dat).

Dades tractades en format JSON: [meteo.json](http://ulisses.fis.ub.edu:8001/services/meteo/meteo.json)

Utilització
-----------

```ruby
require 'meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => "tmp/www.dat"
puts meteo.temperature	# => 13.9
```

Todo
----
* Twitter: respostes en funció de les mencions
* Afegir més dades (velcitat del vent, direcció, etc.)