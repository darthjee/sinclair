# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Define a method from block
    class InstanceBlockDefinition < BlockDefinition
      private

      # @private
      #
      # Method used to define an instance method
      #
      # @return [Symbol] Always :define_method
      def method_definer
        :define_method
      end
    end
  end
end
