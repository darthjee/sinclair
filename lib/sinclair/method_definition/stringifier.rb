# frozen_string_literal: true

require 'sinclair/core_ext/object'

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Stringgify a value for {StringDefinition}
    class Stringifier < Caster
      master_caster!

      cast_with(NilClass) { 'nil' }
      cast_with(Symbol) { |value| ":#{value}" }
      cast_with(Class, :to_s)
      cast_with(Hash, :to_s)
      cast_with(Array, :to_s)
      cast_with(Object, :to_json)

      # Convert a value to a string format
      #
      # The returned string can be evaluated as code, returning the
      # original value
      #
      # @param value [Object] object to be converted
      #
      # @return [String]
      def self.value_string(value)
        cast(value, value.class)
      end
    end
  end
end
