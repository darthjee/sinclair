# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    # @api private
    # @author darthjee
    #
    # Build a method based on a {MethodDefinition::CallDefinition}
    class CallMethodBuilder < Base
      # Builds the method
      #
      # @return [NilClass]
      def build
        klass.module_eval(code_line, __FILE__, __LINE__ + 1)
      end

      private

      # @api private
      # @private
      #
      # String to be evaluated when building the method
      #
      # This can be {code_string} or {class_code_string}
      # @return (see MethodDefinition::CallDefinition#code_string)
      def code_line
        instance? ? code_string : class_code_string
      end

      delegate :code_string, :class_code_string, to: :definition

      # @method code_string
      # @private
      # @api private
      #
      # Delegated from {MethodDefinition::CallDefinition}
      #
      # @see MethodDefinition::CallDefinition#code_string
      # @return (see MethodDefinition::CallDefinition#code_string)

      # @method class_code_string
      # @private
      # @api private
      #
      # @see MethodDefinition::CallDefinition#class_code_string
      # @return (see MethodDefinition::CallDefinition#class_code_string)
    end
  end
end
