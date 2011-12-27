#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'twitter'
require 'active_record'
require 'lib/meteo_ub.rb'

ActiveRecord::Base.establish_connection(
    :adapter   => "sqlite3",
    :database  => File.dirname(__FILE__) + "/db/meteo_ub.sql"
)

class Mention < ActiveRecord::Base 
end

conf = YAML::load(File.open(File.dirname(__FILE__) + '/conf.yml'))

Twitter.configure do |config|
  config.consumer_key = conf['twitter']['consumer_key']
  config.consumer_secret = conf['twitter']['consumer_secret']
  config.oauth_token = conf['twitter']['token']
  config.oauth_token_secret = conf['twitter']['token_secret']
end

meteo = MeteoUB.new
meteo.parse :file => 'tmp/www.dat'

client = Twitter::Client.new
client.mentions.each do |mention|
  
  unless Mention.exists? :tweet_id => mention.id
    new_mention = Mention.new :tweet_id => mention.id,
                              :text => mention.text,
                              :user => mention.user.screen_name,
                              :user_id => mention.user.id,
                              :created_at => mention.created_at

    # new_mention.save
    resposta = meteo.resposta :pregunta => mention.text
    if resposta != nil
      missatge = "@#{new_mention.user} #{resposta} (#{meteo.datetime.strftime("%H:%M UTC")})"
      puts missatge
      # client.update missatge
    end
  end
end



