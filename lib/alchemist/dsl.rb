module Alchemist
  class DSL
    def initialize(block)
      @block = block
    end

    def run
      instance_eval &@block
    end

    def units(type, &block)
      Library.instance.add_units(type, block)
    end
  end
end
