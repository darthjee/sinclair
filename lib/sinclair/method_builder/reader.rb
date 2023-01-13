# frozen_string_literal: true

class Sinclair
  # @api private
  # @author darthjee
  class MethodBuilder
    class Reader < Base
      def initialize(klass, *attributes, type:)
        @klass      = klass
        @attributes = attributes.flatten
        @type = type
      end

      def build
        if instance?
          klass.attr_reader *attributes
        else
          attrs = attributes
          mod = Module.new do
            attr_reader *attrs
          end
          klass.extend mod
        end
      end

      private

      attr_reader :attributes
    end
  end
end
