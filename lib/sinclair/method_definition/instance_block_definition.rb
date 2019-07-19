# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # Define a method from block
    class InstanceBlockDefinition < BlockDefinition
      private

      def method_definer
        :define_method
      end
    end
  end
end
