# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # Define an class method from block
    class ClassBlockDefinition < BlockDefinition
      private

      def method_definer
        :define_singleton_method
      end
    end
  end
end
