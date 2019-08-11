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
    class StringMethodBuilder < Base
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

      delegate :code_line, :name, to: :definition
    end
  end
end
