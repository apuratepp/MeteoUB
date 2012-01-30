#!/usr/bin/env ruby

require 'lib/meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => "tmp/www.dat-minut-fatidic"

p meteo.dades

puts meteo.temperature.to_s + "ºC"
puts meteo.max_wind_speed.to_s + " m/s"
puts meteo.wind_direction.to_s + "º"
puts "Sunrise: #{meteo.sunrise}"
puts "Sunset: #{meteo.sunset}"