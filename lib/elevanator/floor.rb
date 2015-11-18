class Elevanator
  class Floor
    def initialize(floor_number, building)
      raise ArgumentError unless building.is_a? Building
      @number = floor_number
      @building = building
    end
    attr_reader :number, :building

    def request(direction)
      building.floor_request(direction, self)
    end
  end
end
