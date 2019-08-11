# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    # @api private
    # @author darthjee
    #
    # Class responsible to build methods from
    # string definitions
    #
    # @see MethodDefinition::StringDefinition
    class StringMethodBuilder
      def initialize(klass)
        @klass = klass
      end

      def build_method(definition)
        build_code(definition.code_line, definition.name)
      end

      def build_class_method(definition)
        build_code(definition.code_line, "self.#{definition.name}")
      end

      private

      def build_code(code, declaration)
        code_definition = <<-CODE
        def #{declaration}
          #{code}
        end
        CODE
        klass.module_eval(code_definition, __FILE__, __LINE__ + 1)
      end

      attr_reader :klass
    end
  end
end
