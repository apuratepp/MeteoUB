#!/bin/bash
# Script exemple per baixar les dades meteorològiques al directori adequat

curl "http://infomet.am.ub.es/campbell/www.dat" > "./tmp/www.dat"
curl "http://infomet.am.ub.edu/campbell/maxmin.dat" > "./tmp/maxmin.dat"
curl "http://infomet.am.ub.es/metdata/plu.dat" > "./tmp/plu.dat"
