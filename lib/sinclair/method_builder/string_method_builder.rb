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
      # Builds the method
      #
      # @return (see Base#build)
      def build
        klass.module_eval(code_definition, __FILE__, __LINE__ + 1)
      end

      private

      # @private
      #
      # string used for method name definition
      #
      # the string changes depending if it is
      # a class or instance method
      #
      # @return [String]
      def definition_name
        instance? ? name : "self.#{name}"
      end

      # @private
      #
      # string with the code to be defined
      #
      # @return [String]
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
