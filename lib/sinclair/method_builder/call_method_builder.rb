# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    # @api private
    # @author darthjee
    #
    # Build a method based on a {MethodDefinition::CallDefinition}
    class NewCallMethodBuilder < Base
      # Builds the method
      #
      # @return [NilClass]
      def build
        evaluating_class.module_eval(&code_block)
      end

      delegate :code_block, to: :definition

      def evaluating_class
        return klass if instance?

        class << klass
          return self
        end
      end
    end
  end
end
