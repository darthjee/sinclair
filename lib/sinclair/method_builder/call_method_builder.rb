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
      # The build uses +module_eval+ over a class
      #
      # The code is ran either on the class itself or in
      # a block that allow creation of class methods
      #
      # @return [NilClass]
      def build
        evaluating_class.module_eval(&code_block)
      end

      private

      delegate :code_block, to: :definition
      # @method code_block
      # @api private
      # @private
      #
      # Code block to be evaluated by the class
      #
      # @return [Proc]
    end
  end
end
