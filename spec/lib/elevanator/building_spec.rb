require 'spec_helper'

describe Elevanator::Building do
  let(:default) { described_class.new }
  subject(:building) { default }

  describe "#floors" do
    it "defaults to 10 floors" do
      expect(default.floors.count).to eq(described_class::DEFAULT_FLOOR_NUM)
    end

    it "can set number of floors" do
      num = 10

      set = described_class.new(num_floors: num)

      expect(set.floors.count).to eq(num)
    end
  end

  describe "#elevators" do
    it "defaults to 2 elevators" do
      expect(default.elevators.count).to eq(described_class::DEFAULT_ELEVATOR_NUM)
    end

    it "can set number of elevators" do
      num = 4

      set = described_class.new(num_elevators: num)

      expect(set.elevators.count).to eq(num)
    end
  end

  describe "#floor_request" do
    let(:num) { 3 }
    let(:dir) { :up }
    let(:req) { double }

    before { allow(Elevanator::Request).to receive(:new).and_return(req) }

    it "processes the request" do
      expect(Elevanator::Request).to receive(:new).with(dir, num, building.elevators)
      expect(req).to receive(:process)
      building.floor_request(dir, num)
    end
  end
end
