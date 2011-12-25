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
  end
  
  def parse_file(params)
    if File.exists?(params[:path])
      file = open(params[:path])
      @dades_raw = []
      file.each_line { |line| @dades_raw.push(line) }
      @datetime    = DateTime.strptime(self.dades_raw[0].chomp + " " + self.dades_raw[1].chomp + " UTC", "%d-%m-%y %H:%M %Z")
      @temperature = self.dades_raw[2].chomp.to_f
      @pressure    = self.dades_raw[8].chomp.to_f
      @humidity    = self.dades_raw[5].chomp.to_f
      @plou        = self.dades_raw[22].chomp == 1
    
      @dades = {
        :datetime => @datetime,
        :temperature => @temperature,
        :pressure => @pressure,
        :humidity => @humidity,
        :plou => @plou
      }
    else
      puts "No existeix cap arxiu '#{params[:path]}'"
    end
  end
end