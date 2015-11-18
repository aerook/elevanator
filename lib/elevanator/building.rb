class Elevanator
  class Building

    DEFAULT_FLOOR_NUM = 10
    DEFAULT_ELEVATOR_NUM = 2

    def initialize(num_floors: DEFAULT_FLOOR_NUM, num_elevators: DEFAULT_ELEVATOR_NUM)
      (1..num_floors).each { |i| floors << Floor.new(i, self) }
      num_elevators.times { elevators << Elevator.new }
    end

    def floors
      @floors ||= []
    end

    def elevators
      @elevators ||= []
    end

    def floor_request(direction, floor_number)
      Request.new(direction, floor_number, elevators).process
    end
  end
end
