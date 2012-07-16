module Alchemist
  class Definition
    attr_reader :type
    def initialize(type, unit_name, base, options = {})
      @type, @unit_name, @base = type, unit_name.to_s, base.to_f
      @options = options
    end

    def unit_name(value=1)
      value == 1 ? @unit_name : plural_name
    end

    private

    def plural_name
      @options[:plural] || @unit_name
    end
  end
end

