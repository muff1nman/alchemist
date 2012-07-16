require 'singleton'
module Alchemist
  class Dictionary
    def initialize(type, block)
      @type = type
      @definitions = Runner.new(type, block).definitions
    end

    def define(type)
      @definitions[type.to_sym]
    end

    private
    class Runner
      attr_reader :definitions
      def initialize(type, block)
        @type = type
        @definitions = {}
        instance_eval &block
      end

      def unit(unit_name, *args, &block)
        @definitions[unit_name.to_sym] = Definition.new(@type, unit_name.to_s, 1)
      end

      def method_missing(method, *args, &block)
        unit(method.to_s, *args, &block)
      end
    end
  end


end
