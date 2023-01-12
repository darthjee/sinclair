# frozen_string_literal: true

require 'sinclair/comparable/class_methods'

class Sinclair
  # @api public
  # @author darthjee
  #
  # Concern to be added on classes for easy +==+ comparison
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
