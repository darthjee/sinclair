# frozen_string_literal: true

require 'sinclair/comparable/class_methods'

class Sinclair
  # @api public
  # @author darthjee
  #
  # Concern to be added on classes for easy +==+ comparison
  #
  # @example
  #   class SampleModel
  #     include Sinclair::Comparable
  #
  #     comparable_by :name
  #     attr_reader :name, :age
  #
  #     def initialize(name: nil, age: nil)
  #       @name = name
  #       @age  = age
  #     end
  #   end
  #
  #   model1 = model_class.new(name: 'jack', age: 21)
  #   model2 = model_class.new(name: 'jack', age: 23)
  #
  #    model1 == model2 # returns true
  module Comparable
    extend ActiveSupport::Concern

    # Checks if an instance of a comparable is equals another
    #
    # @param other [Object] an object that should be equal to comparable
    #
    # @return [Boolean]
    # @example (see Sinclair::Comparable)
    def ==(other)
      self.class.equals_checker.match?(self, other)
    end
  end
end
