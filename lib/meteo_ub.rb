# MeteoUB
# Tractament de les dades meteorològiques del 
# Departament d'Astronomia i Meteorologia (Universitat de Barcelona)
# www.am.ub.es - www.ub.edu/fisica

require 'date'

class MeteoUB
  # Array de les dades de l'arxiu www.dat
  attr_accessor :dades_raw
  # Array de les dades de l'arxiu extremes
  attr_accessor :extremes_raw
  
  # DateTime del moment de les mesures (UTC)
  attr_accessor :datetime
  # Float de la temperatura mitjana dels últims 10 min (ºC)
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
  attr_accessor :rain
  # Retorna la velocitat de la raxta màxima de vent dels últims 10 min (m/s)
  attr_accessor :max_wind_speed
  # Retorna la velocitat de la ratxa màxima de vent dels últims 10 min (km/h)
  attr_accessor :max_wind_speed_km_h
  # Retorna la direcció mitjana del vent dels últims 10 min (º)
  attr_accessor :wind_direction
  # Retorna la direcció mitjana del vent dels últims 10 min (windrose)
  attr_accessor :windrose
  # Retorna la precipitació acumulada dels últims 10 min (mm)
  attr_accessor :precipitation
  # Hahs amb temperatura màxima de les últimes 24h amb datetime (ºC, UTC)
  attr_accessor :temperature_max
  # Hash amb temperatura mínima de les últimes 24h amb datetime (ºC, UTC)
  attr_accessor :temperature_min
  
  # Hash de totes dels dades
  attr_accessor :dades
  
  
  # Inicialització de l'array de les dades de l'arxiu
  def initialize
    @dades_raw = []
    @extremes_raw = []
  end
  
  # Mètode per llegir les dades de l'arxiu en el cas que aquest existeixi
  def parse(params)
    if File.exists?(params[:file])
      file = open(params[:file])
      file.each_line { |line| @dades_raw.push(line) }
      @datetime      = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[1].chomp + " UTC", "%d-%m-%y %k:%M %Z")
      
      @temperature    = self.dades_raw[2].chomp.to_f  # ºC
      @pressure       = self.dades_raw[10].chomp.to_f # en hPa
      @humidity       = self.dades_raw[7].chomp.to_f  # %
      @rain           = self.dades_raw[22].chomp == 1 # boolean
      @max_wind_speed = self.dades_raw[12].chomp.to_f # m/s (últims 10 min)
      @max_wind_speed_km_h = @max_wind_speed * 3.6    # km/h (últims 10 min)
      @wind_direction = self.dades_raw[13].chomp.to_f # graus meteorologics (últims 10 min)
      @precipitation  = self.dades_raw[21].chomp.to_f # mm (últims 10 min)
      
      # Windrose
      # http://cbc.riocean.com/wstat/012006rose.html
      case(self.dades_raw[13].chomp.to_f)
      when (0..11.25)
         @windrose = "N"
       when (11.26..33.75)
         @windrose = "NNE"
       when (33.76..56.25)
         @windrose = "NE"
       when (56.26..78.75)
         @windrose = "ENE"
       when (78.76..101.25)
         @windrose = "E"
       when (101.26..123.75)
         @windrose = "ESE"
       when (123.76..146.25)
         @windrose = "SE"
       when (146.26..168.75)
         @windrose = "SSE"
       when (168.76..191.25)
         @windrose = "S"
       when (191.16..213.75)
         @windrose = "SSW"
       when (213.76..236.25)
         @windrose = "SW"
       when (236.26..258.75)
         @windrose = "WSW"
       when (258.76..281.25)
         @windrose = "W"
       when (281.26..303.75)
         @windrose = "WNW"
       when (303.76..326.25)
         @windrose = "NW"
       when (326.26..348.75)
         @windrose = "NNW"
       when (348.76..360.0)
         @windrose = "N"
       else
         @windrose = "???"
      end
      
      # Guardem les hores de sortida i posta de sol
      begin
        sunrise_hh = self.dades_raw[19].chomp.split(":")[0]
        sunrise_mm = self.dades_raw[19].chomp.split(":")[1]
        sunset_hh  = self.dades_raw[20].chomp.split(":")[0]
        sunset_mm  = self.dades_raw[20].chomp.split(":")[1]
        
        # A vegades el minut el l'arxiu és '60'. S'ha de tenir en compte!
        if sunrise_mm == "60"
          sunrise_mm = 0
          sunrise_hh = sunrise_hh.to_i + 1
        end
        if sunset_mm == "60"
          sunset_mm = 0
          sunset_hh = sunset_hh.to_i + 1
        end

        # @sunrise     = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[19].chomp + " UTC", "%d-%m-%y %k:%M %Z")
        # @sunset      = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[20].chomp + " UTC", "%d-%m-%y %k:%M %Z")
        @sunrise     = DateTime.strptime(self.dades_raw[0].chomp + " #{sunrise_hh}:#{sunrise_mm} UTC", "%d-%m-%y %k:%M %Z")
        @sunset      = DateTime.strptime(self.dades_raw[0].chomp + " #{sunset_hh}:#{sunset_mm} UTC", "%d-%m-%y %k:%M %Z")
      rescue
        puts "---------------------------------------------------------------------"
        puts "MeteoUB Error: Problema amb les dates de @sunrise o @sunset"
        puts self.dades_raw[0]
        puts self.dades_raw[19]
        puts self.dades_raw[20]
        puts "---------------------------------------------------------------------"
      end

      # Arxiu 'maxmin.dat' d'on treiem les temperatures extremes de les últimes 24h
      if File.exists?(params[:extremes])
        file_extremes = open(params[:extremes])
        file_extremes.each_line { |line| @extremes_raw.push(line) }

        # Màxima
        maxima_temp = self.extremes_raw[0].split(" ")[0].to_f
        maxima_hour = self.extremes_raw[0].split(" ")[1].chomp
        maxima_date = self.extremes_raw[0].split(" ")[2].chomp
        maxima_datetime = DateTime.strptime(maxima_date + " " + maxima_hour + " UTC", "%Y%m%d %H:%M %Z")
        @temperature_max = {:temperature => maxima_temp, :datetime => maxima_datetime}

        # Mínima
        minima_temp = self.extremes_raw[1].split(" ")[0].to_f
        minima_hour = self.extremes_raw[1].split(" ")[1].chomp
        minima_date = self.extremes_raw[1].split(" ")[2].chomp
        minima_datetime = DateTime.strptime(minima_date + " " + minima_hour + " UTC", "%Y%m%d %H:%M %Z")
        @temperature_min = {:temperature => minima_temp, :datetime => minima_datetime}
        
      end
    
      @dades = {
        :status =>          "OK",
        :datetime =>        @datetime,
        :temperature =>     @temperature,
        :pressure =>        @pressure,
        :humidity =>        @humidity,
        :max_wind_speed =>  @max_wind_speed,
        :wind_direction =>  @wind_direction,
        :windrose =>        @windrose,
        :sunrise =>         @sunrise,
        :sunset =>          @sunset,
        :precipitation =>   @precipitation,
        :rain =>            @rain,
        :temperature_max => @temperature_max,
        :temperature_min => @temperature_min
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
  def sunrise_localtime(params)
    @sunrise + params[:offset].hours
  end
  def sunset_localtime(params)
    @sunset + params[:offset].hours
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