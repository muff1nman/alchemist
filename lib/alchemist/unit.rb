module Alchemist
  class Unit

    def initialize(value, definition)
      @value, @definition = value, definition
    end

    def to_s
      "#{@value} #{@definition.unit_name(@value)}"
    end

  end
end
