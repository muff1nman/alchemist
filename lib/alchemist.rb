require 'alchemist/version'
require 'alchemist/dsl'
require 'alchemist/library'
require 'alchemist/dictionary'
require 'alchemist/definition'
require 'alchemist/unit'

module Alchemist
  def self.define(&block)
    DSL.new(block)
  end
end
