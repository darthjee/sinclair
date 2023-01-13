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
        klass.attr_reader *attributes
      end

      private

      attr_reader :attributes
    end
  end
end
