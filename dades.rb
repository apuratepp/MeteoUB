#!/usr/bin/env ruby
require 'lib/meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => "tmp/www.dat"
p meteo.dades
puts meteo.temperature
