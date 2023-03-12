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
        evaluating_class.module_eval(code_definition, __FILE__, __LINE__ + 1)
      end

      delegate :code_definition, to: :definition
    end
  end
end
