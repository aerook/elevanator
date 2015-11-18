require 'spec_helper'

describe Elevanator::Elevator do
  subject(:elevator) { described_class.new }

  describe "#current_floor" do
    it "defaults to 1" do
      expect(elevator.current_floor).to eq(1)
    end
  end

  describe "#doors" do
    it "starts closed" do
      expect(elevator.doors).to eq(:closed)
    end
  end

  describe "#add_destination" do
    context "when destination is not an int" do
      let(:dest) { "fancypants" }

      it "raises argument error" do
        expect { elevator.add_destination(dest) }.to raise_error { ArgumentError }
      end
    end

    context "when destination is valid" do
      let(:dest) { 4 }

      before { elevator.add_destination(dest) }

      it "adds the destination to the queue" do
        expect(elevator.queue).to include(dest)
      end

      context "when the destination has already been requested" do
        before { elevator.add_destination(dest) }

        it "only adds it to the queue once" do
          expect(elevator.queue.count(dest)).to eq(1)
        end
      end
    end
  end

  describe "#tick" do
    context "when idle" do
      it "does nothing" do
        expect { elevator.tick }.not_to change { elevator.current_floor }
      end
    end

    context "when moving up" do
      before do
        elevator.instance_variable_set(:@current_floor, 1)
        elevator.add_destination(5)
      end

      it "moves the elevator up one level" do
        expect { elevator.tick }.to change { elevator.current_floor }.by(1)
      end
    end

    context "when moving down" do
      before do
        elevator.instance_variable_set(:@current_floor, 5)
        elevator.add_destination(1)
      end

      it "moves the elevator down one level" do
        expect { elevator.tick }.to change { elevator.current_floor }.by(-1)
      end
    end

    context "when doors are open" do
      before do
        elevator.instance_variable_set(:@doors, :open)
        elevator.instance_variable_set(:@current_floor, 3)
        elevator.add_destination(3)
        elevator.add_destination(2)
      end

      it "does not move" do
        expect { elevator.tick }.not_to change { elevator.current_floor }
      end

      it "closes the doors" do
        expect { elevator.tick }.to change { elevator.doors }.from(:open).to(:closed)
      end
    end

    context "when arriving at a requested floor" do
      before do
        elevator.instance_variable_set(:@current_floor, 3)
        elevator.add_destination(1)
        elevator.add_destination(3)
      end

      it "does not move" do
        expect { elevator.tick }.not_to change { elevator.current_floor }
      end

      it "opens the doors" do
        elevator.tick
        expect(elevator.doors).to eq(:open)
      end

      it "removes the floor from the queue" do
        expect(elevator.queue).to include(3)
        elevator.tick
        expect(elevator.queue).not_to include(3)
      end
    end

    context "when multiple floors are requested" do
      before do
        elevator.instance_variable_set(:@current_floor, 3)
        elevator.add_destination(5)
        elevator.add_destination(2)
      end

      before { elevator.tick }

      it "prioritizes floors in the order they are requested" do
        expect(elevator.current_floor).to eq(4)
      end
    end
  end
end
