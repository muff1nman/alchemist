require 'spec_helper'

module Alchemist
  describe ".define" do
    it "can define new units with the DSL" do
      DSL.stubs(:new)
      block = proc {}
      Alchemist.define(&block)
      DSL.should have_received(:new).with(block)
    end
  end
end
