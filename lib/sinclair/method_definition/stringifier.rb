# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Stringgify a value for {StringDefinition}
    class Stringifier
      # Convert a value to a string format
      #
      # The returned string can be evaluated as code, returning the
      # original value
      #
      # @param value [Object] object to be converted
      #
      # @return [String]
      def self.value_string(value)
        return 'nil' if value.nil?
        return ":#{value}" if value.is_a?(Symbol)

        return value.to_s if is_any?(value, Class, Hash, Array)

        value.to_json
      end

      # Checks if an object is an instance of any of the given classes
      #
      # @param value [Object] object to be checkd
      # @param classes [Array<Class>] classes to be checked against object
      #
      # @return [TrueClass,FalseClass]
      def self.is_any?(value, *classes)
        classes.any? do |klass|
          value.is_a?(klass)
        end
      end
    end
  end
end
