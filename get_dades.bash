#!/bin/bash
# Script exemple per baixar les dades meteorològiques al directori adequat

wget "http://infomet.am.ub.es/campbell/www.dat" 	-O "./tmp/www.dat"
wget "http://infomet.am.ub.edu/campbell/maxmin.dat" 	-O "./tmp/maxmin.dat"
wget "http://infomet.am.ub.es/metdata/plu.dat" 		-O "./tmp/plu.dat"
