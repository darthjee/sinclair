# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    # @api private
    # @author darthjee
    #
    # Class responsible to build methods from
    # block definitions
    #
    # @see MethodDefinition::BlockDefinition
    class BlockMethodBuilder < Base
      # Builds the method
      #
      # @return (see Base#build)
      def build
        evaluating_class.define_method(name, method_block)
      end

      delegate :name, :method_block, to: :definition
    end
  end
end
