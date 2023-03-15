# frozen_string_literal: true

class ::Object
  # Checks if an object is an instance of any of the given classes
  #
  # @param classes [Array<Class>] classes to be checked against object
  #
  # @return [TrueClass,FalseClass]
  def is_any?(*classes)
    classes.any? do |klass|
      is_a?(klass)
    end
  end
end

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

        return value.to_s if value.is_any?(Class, Hash, Array)

        value.to_json
      end
    end
  end
end
