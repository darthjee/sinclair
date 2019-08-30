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
      # @return [Symbol]
      def build
        klass.send(method_definition, name, method_block)
      end

      private

      delegate :name, :method_block, to: :definition

      # @private
      #
      # name of the method used to define a new method on class
      #
      # @return [Symbol]
      def method_definition
        instance? ? :define_method : :define_singleton_method
      end
    end
  end
end
