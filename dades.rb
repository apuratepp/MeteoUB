#!/usr/bin/env ruby

require 'lib/meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => "tmp/www.dat"

p meteo.dades
puts meteo.temperature.to_s + "ºC"
puts meteo.wind_speed.to_s + " m/s"
