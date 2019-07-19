# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # Define a method from string
    class ClassStringDefinition < StringDefinition
      private

      def code_name
        "self.#{name}"
      end
    end
  end
end
