# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Define a method from string
    class ClassStringDefinition < StringDefinition
      def build(klass)
        MethodBuilder.new(klass).build_class_method(self)
      end

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
