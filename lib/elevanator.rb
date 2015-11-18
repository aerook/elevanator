class Elevanator
  class << self
    def start(ops={})
      @building = Building.new(ops)
    end
    attr_reader :building

    def tick
      building.elevators.each(&:tick)
      self
    end
  end
end

Dir["#{File.dirname(__FILE__)}/elevanator/**/*.rb"].each { |f| load(f) }
