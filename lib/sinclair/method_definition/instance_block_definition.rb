# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Define a method from block
    class InstanceBlockDefinition < BlockDefinition
      def build(klass)
        MethodBuilder.new(klass).build_method(self)
      end

      private

      # @private
      #
      # Method used to define an instance method
      #
      # @return [Symbol] Always :define_method
      default_value :method_definer, :define_method
    end
  end
end
