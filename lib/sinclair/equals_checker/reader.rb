# frozen_string_literal: true

class Sinclair
  class EqualsChecker
    # @api private
    # @author darthjee
    #
    # Class capable of reading an attribute from models
    class Reader
      class << self
        # @private
        # @api private
        #
        # Checks if two attributes from 2 object match
        #
        # @param attribute [Symbol] attribute name
        # @param model [Object] object to be compared with other
        # @param other [Object] object to be compared with model
        #
        # @see #match?
        # @return [TrueClass,FalseClass]
        def attributes_match?(attribute, model, other)
          reader = new(attribute)

          reader.read_from(model) == reader.read_from(other)
        end
      end

      def initialize(attribute)
        @attribute = attribute
      end

      def read_from(model)
        if attribute.to_s.match?(/^@.*/)
          model.instance_variable_get(attribute)
        else
          model.send(attribute)
        end
      end

      private

      attr_reader :attribute
    end
  end
end
