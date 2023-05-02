# frozen_string_literal: true

class Sinclair
  class EqualsChecker
    # @api private
    # @author darthjee
    #
    # Class capable of reading an attribute from models
    class Reader
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
      def self.attributes_match?(attribute, model, other)
        reader = new(attribute)

        reader.read_from(model) == reader.read_from(other)
      end

      # @param attribute [Symbol] name of the attribute (method or variable)
      #   to be accessed in the models
      def initialize(attribute)
        @attribute = attribute
      end

      # Reads the +attribute+ from the model
      #
      # When attribute is a method name, calls that method on the model
      # 
      # When attribute is an instance variable name, that is read directly from the model
      #
      # @param model [Object] the model to be read
      #
      # @return [Object]
      def read_from(model)
        return model.send(attribute) unless attribute.to_s.match?(/^@.*/)

        model.instance_variable_get(attribute)
      end

      private

      # @attr_reader :attribute
      #
      # Reads the attribute that will be used to extract the value
      #
      # @return [Symbol]
      attr_reader :attribute
    end
  end
end
