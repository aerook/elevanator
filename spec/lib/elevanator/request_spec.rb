require 'spec_helper'

describe Elevanator::Request do
  ##
  # These specs will be sorta nasty in the setup:
  #   they're meant to describe how the elevator
  #   assignment logic works under various conditions.
  describe "#process" do
    let(:floor) { double(number: floor_number) }
    subject { described_class.new(direction, floor, elevators) }

    context "when an idle elevator is on the requested floor" do
      let(:direction) { :up }
      let(:floor_number) { 3 }
      let(:correct_elevator) { double(current_floor: floor_number, idle?: true) }
      let(:wrong_elevator) { double(current_floor: floor_number - 1, idle?: true) }
      let(:elevators) { [correct_elevator, wrong_elevator] }

      it "assigns the floor to that elevator" do
        expect(correct_elevator).to receive(:add_destination).with(floor_number)
        expect(wrong_elevator).not_to receive(:add_destination)
        subject.process
      end
    end

    context "when idle elevators are available on different floors" do
      let(:direction) { :up }
      let(:floor_number) { 3 }
      let(:correct_elevator) { double(current_floor: floor_number + 1, idle?: true) }
      let(:wrong_elevator) { double(current_floor: floor_number - 1, idle?: false) }
      let(:elevators) { [correct_elevator, wrong_elevator] }


      it "assigns the floor to an idle elevator" do
        expect(correct_elevator).to receive(:add_destination).with(floor_number)
        expect(wrong_elevator).not_to receive(:add_destination)
        subject.process
      end
    end

    context "noe idle elevators and no elevators passing" do
      let(:direction) { :up }
      let(:floor_number) { 3 }
      let(:correct_elevator) { double(current_floor: floor_number + 2, idle?: false, direction: :down) }
      let(:elevators) { [correct_elevator] }

      it "randomly picks an elevator" do
        expect(correct_elevator).to receive(:add_destination).with(floor_number)
        subject.process
      end
    end

    context "no idle elevators" do
      let(:direction) { :up }
      let(:floor_number) { 3 }
      let(:correct_elevator) { double(current_floor: floor_number - 1, idle?: false) }
      let(:wrong_elevator) { double(current_floor: floor_number + 1, idle?: false) }
      let(:elevators) { [correct_elevator, wrong_elevator] }

      before do
        allow(correct_elevator).to receive(:direction).and_return(:up)
        allow(wrong_elevator).to receive(:direction).and_return(:down)
      end

      it "assigns the floor to an elevator that is passing the floor in the correct direction" do
        expect(correct_elevator).to receive(:add_destination).with(floor_number)
        expect(wrong_elevator).not_to receive(:add_destination)
        subject.process
      end
    end
  end
end
