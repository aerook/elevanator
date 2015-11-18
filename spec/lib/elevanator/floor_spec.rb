require 'spec_helper'

describe Elevanator::Floor do
  let(:number) { 5 }
  let(:building) { double }
  subject(:floor) { described_class.new(number, building) }

  before { allow(building).to receive(:is_a?).with(Elevanator::Building).and_return(true) }

  describe "#initialize" do

    it "sets the floor number" do
      expect(floor.number).to eq(number)
    end

    it "sets the building" do
      expect(floor.building).to eq(building)
    end
  end

  describe "#request" do
    let(:direction) { :down }

    it "passes the request to the building" do
      expect(building).to receive(:floor_request).with(direction, floor)
      floor.request(direction)
    end
  end
end
