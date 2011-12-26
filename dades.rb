#!/usr/bin/env ruby
require 'lib/meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => "tmp/www.dat"

# puts meteo.datetime
# p meteo.dades
puts meteo.datetime
puts meteo.sunrise
puts meteo.sunset
puts meteo.temperature
puts meteo.humidity
puts meteo.pressure