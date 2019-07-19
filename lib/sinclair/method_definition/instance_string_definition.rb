# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # Define an instance method from string
    class InstanceStringDefinition < StringDefinition
      # Adds the method to given klass
      #
      # @param klass [Class] class which will receive the new method
      #
      # @see MethodDefinition#build
      #
      # @return [Symbol] name of the created method
      def build(klass)
        klass.module_eval(code_definition, __FILE__, __LINE__ + 1)
      end

      private

      def code_name
        name
      end
    end
  end
end
