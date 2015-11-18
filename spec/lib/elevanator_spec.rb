require 'spec_helper'

describe Elevanator do

  describe ".start" do
    it "constructs a building" do
      expect(described_class.building).to be_nil
      described_class.start
      expect(described_class.building).not_to be_nil
    end
  end
end
