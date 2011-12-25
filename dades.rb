#!/usr/bin/env ruby
require 'lib/meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse_file :path => "tmp/www.dat"

puts meteo.datetime
p meteo.dades