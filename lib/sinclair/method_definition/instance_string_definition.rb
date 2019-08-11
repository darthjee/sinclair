# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Define an instance method from string
    class InstanceStringDefinition < StringDefinition
      private

      # @private
      #
      # String used when defining method
      #
      # Instance definition always returns +name+
      #
      # @return [String]
      def method_name
        name
      end
    end
  end
end
