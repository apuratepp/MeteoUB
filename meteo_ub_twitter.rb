#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'twitter'
require 'active_record'
require 'active_support/all'
require File.dirname(__FILE__) + '/lib/meteo_ub.rb'

ActiveRecord::Base.establish_connection(
    :adapter   => "sqlite3",
    :database  => File.dirname(__FILE__) + "/db/meteo_ub.sql"
)

class Mention < ActiveRecord::Base 
end
class Rain < ActiveRecord::Base
end

conf = YAML::load(File.open(File.dirname(__FILE__) + '/conf.yml'))
PUBLISH = conf['publish'] || false

puts "No s'està publicant el missatge (PUBLISH = #{PUBLISH})" if !PUBLISH
Time.zone = conf['time_zone'] || 'UTC'

Twitter.configure do |config|
  config.consumer_key = conf['twitter']['consumer_key']
  config.consumer_secret = conf['twitter']['consumer_secret']
  config.oauth_token = conf['twitter']['token']
  config.oauth_token_secret = conf['twitter']['token_secret']
end

meteo = MeteoUB.new
meteo.parse :file =>      File.dirname(__FILE__) + '/tmp/www.dat', 
            :extremes =>  File.dirname(__FILE__) + '/tmp/maxmin.dat'

client = Twitter::Client.new

case ARGV[0]
when '--mentions':
  client.mentions.each do |mention|
    unless Mention.exists? :tweet_id => mention.id
      new_mention = Mention.new :tweet_id => mention.id,
                                :text => mention.text,
                                :user => mention.user.screen_name,
                                :user_id => mention.user.id,
                                :created_at => mention.created_at

      new_mention.save
      resposta = meteo.resposta :pregunta => mention.text
      if resposta != nil
        missatge = "@#{new_mention.user} #{resposta} a les #{meteo.localtime(:offset => +1).strftime("%H:%M")}"
        client.update(missatge, :lat => conf['location']['lat'], :long => conf['location']['long'], :in_reply_to_status_id => mention.id) if PUBLISH
      end
    end
  end
when '--update':
  # Comprovar que les dades siguin de fa menys d'una hora
  if meteo.datetime > (Time.now - 1.hour)
    # missatge = "#{meteo.temperature}ºC a les #{meteo.localtime(:offset => +1).strftime("%H:%M")} a #Barcelona #Física #UB"
    missatge = "#{meteo.temperature}ºC a les #{meteo.datetime.in_time_zone.strftime("%H:%M")} a #Barcelona #Física #UB"
    # puts missatge
    client.update(missatge, :lat => conf['location']['lat'], :long => conf['location']['long']) if PUBLISH
  else
    puts "Les dades són de fa més d'una hora :("
  end
when '--summary':  
  # missatge = "Dades a les #{meteo.localtime(:offset => +1).strftime("%H:%M")}: #{meteo.temperature}ºC, #{meteo.humidity}%, #{meteo.pressure} hPa, X km/h XYZ // Màx ahir: XX.XºC, min avui: XX.XºC // Sortida: HH:MM, posta: HH:MM"
  missatge = "Dades a les #{meteo.datetime.in_time_zone.strftime("%H:%M")}: #{meteo.temperature}ºC, #{meteo.humidity}%, #{meteo.pressure} hPa, #{meteo.max_wind_speed_km_h.to_i} km/h #{meteo.windrose} // Màx ahir: #{meteo.temperature_max[:temperature]}ºC, min avui: #{meteo.temperature_min[:temperature]}ºC // Sortida del Sol: #{meteo.sunrise_localtime(:offset => +1).strftime("%H:%M")}, posta: #{meteo.sunset_localtime(:offset => +1).strftime("%H:%M")}"
  if !PUBLISH
    puts missatge
    puts "#{missatge.length} caràcters"
  end
  
  # Comprovar que les dades siguin de fa menys d'una hora
  if meteo.datetime > (Time.now - 1.hour)
    client.update(missatge, :lat => conf['location']['lat'], :long => conf['location']['long']) if PUBLISH
  else
    puts "Les dades són de fa més d'una hora :("
  end
when '--rain'
  if !meteo.rain && meteo.datetime > (Time.now - 1.hour)
    if Rain.all.last.created_at < 6.hours.ago
      Rain.new(:created_at => Time.now).save
      missatge = "(Avís en proves) S'ha detectat que plou al terrat de la Facultat de Física"
      puts missatge if !PUBLISH
      client.update(missatge, :lat => conf['location']['lat'], :long => conf['location']['long']) if PUBLISH
    else
      puts "Fa menys de 6 hores que ja ha sortit l'avís de que plou"
    end
  else
    # puts "No plou o les dades són de fa més d'1 hora"
  end
else  
  puts "Usage:
      ruby twitter.rb --mentions        comprova les mencions i respon
      ruby twitter.rb --summary         resum diari amb diverses dades
      ruby twitter.rb --update          actualitza amb la temperatura actual
      ruby twitter.rb --rain            mostra avís per twitter si està plovent
      
      Més informació: https://github.com/apuratepp/MeteoUB
"
end




