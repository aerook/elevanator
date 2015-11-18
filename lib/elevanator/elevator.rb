class Elevanator
  class Elevator

    def initialize
      @current_floor = 1
      @doors = :closed
      @queue = []
    end
    attr_reader :current_floor, :doors, :queue

    def add_destination(destination_floor)
      raise ArgumentError unless valid_floor_number?(destination_floor)
      @queue << destination_floor
      @queue.uniq!
    end

    def set_destination(destination_floor)
      raise ArgumentError unless valid_floor_number?(destination_floor)
      @queue.insert(0, destination_floor)
      @queue.uniq!
    end

    def idle?
      doors_closed? && queue.empty?
    end

    def tick
      if doors_open?
        close_doors
      elsif current_floor_requested?
        open_doors
        @queue.delete current_floor
      elsif moving?
        move
        # else noop
      end
      self
    end

    def direction
      if @queue.empty?
        nil
      elsif current_floor < target_floor
        :up
      elsif current_floor > target_floor
        :down
      end
    end

    private

    def target_floor
      @queue.first
    end

    def moving?
      !direction.nil?
    end

    def move
      delta = case direction
              when :up
                1
              when :down
                -1
              end
      @current_floor += delta
    end

    def current_floor_requested?
      @queue.include? current_floor
    end

    def doors_open?
      @doors == :open
    end

    def doors_closed?
      @doors == :closed
    end

    def open_doors
      @doors = :open
    end

    def close_doors
      @doors = :closed
    end

    def valid_floor_number?(n)
      n.is_a? Integer
    end
  end
end
