#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'twitter'
require 'active_record'
require File.dirname(__FILE__) + '/lib/meteo_ub.rb'

ActiveRecord::Base.establish_connection(
    :adapter   => "sqlite3",
    :database  => File.dirname(__FILE__) + "/db/meteo_ub.sql"
)

class Mention < ActiveRecord::Base 
end

conf = YAML::load(File.open(File.dirname(__FILE__) + '/conf.yml'))
PUBLISH = conf['publish'] || false
puts "No s'està publicant el missatge (PUBLISH = #{PUBLISH})" if !PUBLISH

Twitter.configure do |config|
  config.consumer_key = conf['twitter']['consumer_key']
  config.consumer_secret = conf['twitter']['consumer_secret']
  config.oauth_token = conf['twitter']['token']
  config.oauth_token_secret = conf['twitter']['token_secret']
end

meteo = MeteoUB.new
meteo.parse :file => File.dirname(__FILE__) + '/tmp/www.dat'

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
  if meteo.datetime > (Time.now - 3600)
    missatge = "#{meteo.temperature}ºC a les #{meteo.localtime(:offset => +1).strftime("%H:%M")} #Física #UB #Barcelona"
    puts missatge
    client.update(missatge, :lat => conf['location']['lat'], :long => conf['location']['long']) if PUBLISH
  else
    puts "Les dades són de fa més d'una hora :("
  end
else  
  puts "Usage:
      ruby twitter.rb --mentions        comprova les mencions i respon
      ruby twitter.rb --update          actualitza amb la temperatura actual
      
      Més informació: https://github.com/apuratepp/MeteoUB
"
end




