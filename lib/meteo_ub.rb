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
  
  def initialize
    @dades_raw = []
  end
  
  def parse(params)
    if File.exists?(params[:file])
      file = open(params[:file])
      file.each_line { |line| @dades_raw.push(line) }
      @datetime    = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[1].chomp + " UTC", "%d-%m-%y %k:%M %Z")
      @temperature = self.dades_raw[2].chomp.to_f
      @pressure    = self.dades_raw[8].chomp.to_f
      @humidity    = self.dades_raw[5].chomp.to_f
      @plou        = self.dades_raw[22].chomp == 1
      @sunrise     = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[19].chomp + " UTC", "%d-%m-%y %k:%M %Z")
      @sunset      = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[20].chomp + " UTC", "%d-%m-%y %k:%M %Z")
    
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