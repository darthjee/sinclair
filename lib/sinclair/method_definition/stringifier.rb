# frozen_string_literal: true

require 'sinclair/core_ext/object'

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
