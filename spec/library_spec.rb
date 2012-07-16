require 'spec_helper'

module Alchemist
  describe Library do
    before(:each) { library.clear }

    it "can #add_units with type" do
      library.add_units(:length, proc{})
      library.types.should have_key(:length)
    end

    it "can #add_units with definition" do
      Dictionary.stubs(:new)
      block = proc{}
      library.add_units(:length, block)
      Dictionary.should have_received(:new).with(:length, block)
    end

    it "can #get a specific dictionary" do
      dictionary = stub(:dictionary)
      Dictionary.stubs(:new).returns(dictionary)
      library.add_units(:length, proc{})
      library.get(:length).should == dictionary
    end

    def library
      Library.instance
    end

  end
end
