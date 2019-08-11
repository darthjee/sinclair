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
      def build
        klass.send(method_definition, name, method_block)
      end

      private

      delegate :name, :method_block, to: :definition

      def method_definition
        instance? ? :define_method : :define_singleton_method
      end
    end
  end
end
