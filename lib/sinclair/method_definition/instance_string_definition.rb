# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # Define an instance method from string
    class InstanceStringDefinition < StringDefinition
      private

      def code_name
        name
      end
    end
  end
end
