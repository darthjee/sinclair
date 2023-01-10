# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  class EqualsBuilder
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end
    
    def match?(model, other)
      return false unless model.class == other.class
      true
    end
  end
end
