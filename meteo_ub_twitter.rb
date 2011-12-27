#!/usr/bin/env ruby

require 'rubygems'
require 'active_record'
require 'lib/meteo_ub.rb'

meteo = MeteoUB.new
meteo.parse :file => 'tmp/www.dat'

puts meteo.temperature