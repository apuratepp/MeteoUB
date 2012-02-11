#!/usr/bin/env ruby

require 'lib/meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => "tmp/www.dat", :extremes => "tmp/maxmin.dat"

#p meteo.dades

# puts meteo.temperature.to_s + "ºC"
# puts meteo.max_wind_speed.to_s + " m/s"
# puts meteo.max_wind_speed_km_h.to_s + " km/h"
# puts meteo.wind_direction.to_s + "º"
# puts meteo.windrose
# puts "Sunrise: #{meteo.sunrise}"
# puts "Sunset: #{meteo.sunset}"

puts meteo.temperature_min[:temperature]
puts meteo.temperature_min[:datetime].strftime("%H:%M %d/%m/%Y")
puts ""
puts meteo.temperature_max[:temperature]
puts meteo.temperature_max[:datetime].strftime("%H:%M %d/%m/%Y")