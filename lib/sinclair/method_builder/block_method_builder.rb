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
    class BlockMethodBuilder
      def initialize(klass, definition, type: :instance)
        @klass = klass
        @definition = definition
        @type = type
      end

      def build
        klass.send(method_definition, name, method_block)
      end

      private

      attr_reader :klass, :definition, :type

      delegate :name, :method_block, to: :definition

      def instance?
        type == :instance
      end

      def method_definition
        instance? ? :define_method : :define_singleton_method
      end
    end
  end
end
