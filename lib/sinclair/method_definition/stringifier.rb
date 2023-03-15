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
        return hash_string(value) if value.is_a?(Hash)

        value.to_json
      end

      def self.hash_string(hash)
        entries = hash.map do |key, value|
          [
            value_string(key),
            value_string(value)
          ].join(' => ')
        end.join(', ')

        "{ #{entries} }"
      end
    end
  end
end
