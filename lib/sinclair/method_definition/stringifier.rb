# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    class Stringifier
      def self.value_string(value)
        return 'nil' if value.nil?
        return ":#{value}" if value.is_a?(Symbol)
        return value.to_s if value.is_a?(Class)
        return value.to_s if value.is_a?(Hash)
        return value.to_s if value.is_a?(Array)

        value.to_json
      end

      def array_value_string(array)
        strings = array.map do |value|
          value_string(value)
        end.join(', ')

        return  "[#{strings}]"
      end
    end
  end
end
