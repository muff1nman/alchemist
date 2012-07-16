require 'spec_helper'

module Alchemist
  describe Unit do
    it "converts to string for singular" do
      unit(1, :meter).to_s.should == "1 meter"
    end

    it "converts to plural form for multiple" do
      unit(2, :meter).to_s.should == "2 meters"
    end

    def unit(value, type)
      Alchemist::Unit.new(value, definition)
    end

    def definition
      Alchemist::Definition.new(:length, :meter, 1, plural: 'meters', short: 'm')
    end
  end

end
