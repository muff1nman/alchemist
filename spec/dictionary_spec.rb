require 'spec_helper'

module Alchemist
  describe Dictionary::Runner do
    it "create a definition from a block" do
      Definition.stubs(:new).returns("meter")
      runner = Dictionary::Runner.new(:length, proc{ meter })
      Definition.should have_received(:new).with(:length, 'meter', 1)
      runner.definitions[:meter].should == "meter"
    end

  end

  describe Dictionary do
    it "can initialize the block" do
      Dictionary::Runner.stubs(:new).returns(runner)
      block = proc{}
      dictionary = Dictionary.new(:length, block)
      Dictionary::Runner.should have_received(:new).with(:length, block)
    end

    it "can #define a unit" do
      Dictionary::Runner.stubs(:new).returns(runner)
      dictionary = Dictionary.new(:length, proc{ meter })
      dictionary.define('meter').should == 'meter'
    end

    def runner
      stub('runner', definitions: { meter: 'meter' })
    end
  end

end
