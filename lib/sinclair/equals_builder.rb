# frozen_string_literal: true

class Sinclair
  # @api protected
  # @author darthjee
  class EqualsBuilder
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
    end

    def match?(model, other)
      return false unless model.class == other.class

      attributes.all? do |attr|
        model.send(attr) == other.send(attr)
      end
    end
  end
end
