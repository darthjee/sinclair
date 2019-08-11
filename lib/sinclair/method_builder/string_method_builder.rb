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
      def initialize(klass, definition, type: :instance)
        @klass = klass
        @definition = definition
        @type = type
      end

      def build
        klass.module_eval(code_definition, __FILE__, __LINE__ + 1)
      end

      private

      def definition_name
        instance? ? name : "self.#{name}"
      end

      def code_definition
        <<-CODE
          def #{definition_name}
            #{code_line}
          end
        CODE
      end

      attr_reader :klass, :definition, :type

      delegate :code_line, :name, to: :definition

      def instance?
        type == :instance
      end
    end
  end
end
