# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Define an class method from block
    class ClassBlockDefinition < BlockDefinition
      private

      # @private
      #
      # Method used to define a class method
      #
      # @return [Symbol] Always :define_singleton_method
      def method_definer
        :define_singleton_method
      end
    end
  end
end
