#!/usr/bin/env ruby

require 'lib/meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => "tmp/www.dat", :extremes => "tmp/maxmin.dat"

puts meteo.temperature
p meteo.dades
