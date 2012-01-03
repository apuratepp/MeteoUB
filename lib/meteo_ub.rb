# MeteoUB
# Tractament de les dades meteorològiques del 
# Departament d'Astronomia i Meteorologia (Universitat de Barcelona)
# www.am.ub.es - www.ub.edu/fisica

require 'date'

class MeteoUB
  # Array de les dades de l'arxiu
  attr_accessor :dades_raw
  # DateTime del moment de les mesures
  attr_accessor :datetime
  # Float de la temperatura mitjana (ºC)
  attr_accessor :temperature
  # Float de la pressió atmosfèrica mitjana (hPa)
  attr_accessor :pressure
  # Float de la humitat relativa mitjana (%)
  attr_accessor :humidity
  # DateTime de l'hora de la sortida del Sol
  attr_accessor :sunrise
  # DateTime de l'hora de la posta del Sol
  attr_accessor :sunset
  # Retorna un boolean si plou o no
  attr_accessor :plou
  # Retorna la velocitat del vent
  attr_accessor :wind_speed
  
  # Hash de totes dels dades
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
      @datetime      = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[1].chomp + " UTC", "%d-%m-%y %k:%M %Z")
      @temperature   = self.dades_raw[4].chomp.to_f
      @pressure      = self.dades_raw[10].chomp.to_f
      @humidity      = self.dades_raw[7].chomp.to_f
      @plou          = self.dades_raw[22].chomp == 1
      @wind_speed    = self.dades_raw[12].chomp.to_f
      
      # A vegades el minut el l'arxiu és '60'. S'ha de tenir en compte!
      begin
        @sunrise     = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[19].chomp + " UTC", "%d-%m-%y %k:%M %Z")
        @sunset      = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[20].chomp + " UTC", "%d-%m-%y %k:%M %Z")
      rescue
        puts "Problema amb les dates de @sunrise o @sunset"
      end
    
      @dades = {
        :status => "OK",
        :datetime => @datetime,
        :temperature => @temperature,
        :pressure => @pressure,
        :humidity => @humidity,
        :wind_speed => @wind_speed,
        :plou => @plou,
        :sunrise => @sunrise,
        :sunset => @sunset
      }
    else
      puts "No existeix cap arxiu '#{params[:file]}'"
      @dades = {
        :status => "KO",
        :error => 1,
        :message => "No s'han pogut obtenir les dades"
      }
    end
  end
  
  # Mètode per convertir de UTC a hora local amb un offset (integer)
  def localtime(params)
    @datetime + params[:offset].hours
  end

  # Mètode per generar resposted adequades a la informació demanada
  def resposta(params)
    mention = params[:pregunta]
    paraules = mention.scan(/\w+/)
    
    if paraules.include? "temperatura"
      return "La temperatura a la Facultat és de #{@temperature}ºC"
    elsif paraules.include? "humitat"
      return "La humitat relativa és del #{@humidity} %"
    elsif paraules.include? "pressió"
      return "La pressió és de #{@pressure} hPa"
    elsif paraules.include? "sortida"
      return "La sortida del Sol està prevista a les #{@sunrise.strftime("%H:%M UTC")}"
    elsif paraules.include? "posta"
      return "La posta de Sol està prevista a les #{@sunset.strftime("%H:%M UTC")}"
    end
  end


end