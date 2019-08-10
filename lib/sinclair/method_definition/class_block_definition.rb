# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Define an class method from block
    class ClassBlockDefinition < BlockDefinition
      def build(klass)
        MethodBuilder.new(klass).build_class_method(self)
      end

      private

      # @private
      #
      # Method used to define a class method
      #
      # @return [Symbol] Always :define_singleton_method
      default_value :method_definer, :define_singleton_method
    end
  end
end
