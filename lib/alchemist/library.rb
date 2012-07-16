require 'singleton'
module Alchemist
  class Library
    include Singleton
    attr_reader :types
    def initialize
      @types = {}
    end

    def add_units(type, block)
      dictionary = Dictionary.new(type, block)
      @types[type.to_sym] ||= dictionary
    end

    def get(type)
      @types[type.to_sym]
    end

    def clear
      @types = {}
    end
  end
end
