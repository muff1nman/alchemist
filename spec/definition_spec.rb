require 'spec_helper'

module Alchemist
  describe Definition do
    it "knows the #type" do
      definition.type.should == :length
    end

    it "knows the #unit_name for singular" do
      definition.unit_name == 'meter'
      definition.unit_name(1) == 'meter'
    end

    it "knows the #unit_name for plural" do
      definition.unit_name(0) == 'meters'
      definition.unit_name(2) == 'meters'
    end

    def definition
      Definition.new(:length, :meter, 1, plural: 'meters', short: 'm')
    end
  end
end
