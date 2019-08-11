# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    class BlockMethodBuilder
      def initialize(klass)
        @klass = klass
      end

      def build_method(definition)
        klass.send(:define_method, definition.name, definition.method_block)
      end

      def build_class_method(definition)
        klass.send(:define_singleton_method, definition.name, definition.method_block)
      end

      private

      attr_reader :klass
    end
  end
end
