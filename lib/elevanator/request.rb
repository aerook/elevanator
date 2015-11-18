class Elevanator::Request
  def initialize(direction, floor, elevators)
    @direction = direction
    @floor_number = floor.number
    @elevators = elevators
  end

  def process
    # priority:
    #  idle on floor
    #  idle off floor
    #  heading in that direction
    #  random.
    elevator = idle_on_floor ||
               idle_off_floor ||
               passing_requested_floor ||
               random_elevator
    elevator.add_destination(floor_number)
  end

  private

  attr_reader :direction, :floor_number, :elevators

  def idle_on_floor
    elevators.find { |el| el.idle? && el.current_floor == floor_number }
  end

  def idle_off_floor
    elevators.find { |el| el.idle? }
  end

  def passing_requested_floor
    elevators.find { |el| passing_floor?(el) }
  end

  def random_elevator
    elevators.sample
  end

  def passing_floor?(elevator)
    return false unless elevator.direction == direction
    case direction
    when :up
      elevator.current_floor <= floor_number
    when :down
      elevator.current_floor >= floor_number
    end
  end
end
