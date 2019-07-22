# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # Define a method from string
    class ClassStringDefinition < StringDefinition
      private

      # @private
      #
      # String used when defining method
      #
      # Class definition appends +self.+ to method name
      #
      # @return [String]
      def method_name
        "self.#{name}"
      end
    end
  end
end
