# frozen_string_literal: true

class Sinclair
  # @api protected
  # @author darthjee
  #
  # Class responsible for checking if two instances of a class are the equals
  #
  # @example
  class EqualsBuilder
    attr_reader :attributes

    # @param attributes [Array<Symbol,String>] list of relevant attributes
    def initialize(*attributes)
      @attributes = attributes.flatten
    end

    # Returns if 2 objects are equals
    #
    # The check takes into consideration:
    #   - They should be instances of the same class
    #   - Their attributes (method calls) should return the same value,
    #   for the configured attributes
    #   - Public and private attributes are checked
    #
    # @return  [TrueClass,FalseClass]
    def match?(model, other)
      return false unless model.class == other.class

      attributes.all? do |attr|
        model.send(attr) == other.send(attr)
      end
    end
  end
end
