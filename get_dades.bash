#!/bin/bash
# Script exemple per baixar les dades meteorològiques al directori adequat

curl "http://infomet.am.ub.es/campbell/www.dat" > "/home/apuratep/sites/MeteoUB/tmp/www.dat"
curl "http://infomet.am.ub.es/campbell/www.dat" > "/home/apuratep/sites/secretaria/tmp/dades.dat"
curl "http://infomet.am.ub.edu/campbell/maxmin.dat" > "/home/apuratep/sites/MeteoUB/tmp/maxmin.dat"
curl "http://infomet.am.ub.es/metdata/plu.dat" > "/home/apuratep/sites/MeteoUB/tmp/plu.dat"
