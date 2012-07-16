require 'spec_helper'

module Alchemist
  describe DSL do
    describe "run" do
      it "evaluates the block in context" do
        block = proc { self }
        instance = DSL.new(block)
        instance.run.should == instance
      end
    end

    describe "dsl" do
      it "defines types of #units" do
        Library.instance.stubs(:add_units)
        unit_block = proc {}
        block = proc do
          units(:length, &unit_block)
        end
        DSL.new(block).run
        Library.instance.should have_received(:add_units).
          with(:length, unit_block)
      end
    end
  end
end
