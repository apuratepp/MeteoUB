# MeteoUB
# Tractament de les dades meteorològiques del Departament d'Astronomia i Meteorologia 
# de la Universitat de Barcelona

require 'date'

class MeteoUB
  attr_accessor :dades_raw
  attr_accessor :datetime
  attr_accessor :temperature
  attr_accessor :pressure
  attr_accessor :humidity
  attr_accessor :sunrise
  attr_accessor :sunset
  attr_accessor :plou
  attr_accessor :dades
  
  # Inicialització de l'array de les dades de l'arxiu
  def initialize
    @dades_raw = []
  end
  
  # Mètode per llegir les dades de l'arxiu en el cas que aquest existeixi
  def parse(params)
    if File.exists?(params[:file])
      file = open(params[:file])
      file.each_line { |line| @dades_raw.push(line) }
      @datetime    = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[1].chomp + " UTC", "%d-%m-%y %k:%M %Z")
      @temperature = self.dades_raw[4].chomp.to_f
      @pressure    = self.dades_raw[10].chomp.to_f
      @humidity    = self.dades_raw[7].chomp.to_f
      @plou        = self.dades_raw[22].chomp == 1
      
      # A vegades el minut el l'arxiu és '60'. S'ha de tenir en compte!
      begin
        @sunrise     = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[19].chomp + " UTC", "%d-%m-%y %k:%M %Z")
        @sunset      = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[20].chomp + " UTC", "%d-%m-%y %k:%M %Z")
      rescue
        puts "Problema amb les dates de @sunrise o @sunset"
      end
    
      @dades = {
        :datetime => @datetime,
        :temperature => @temperature,
        :pressure => @pressure,
        :humidity => @humidity,
        :plou => @plou,
        :sunrise => @sunrise,
        :sunset => @sunset
      }
    else
      puts "No existeix cap arxiu '#{params[:file]}'"
    end
  end
end