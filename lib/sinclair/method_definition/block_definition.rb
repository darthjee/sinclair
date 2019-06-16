# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    class BlockDefinition < MethodDefinition
      # @param name    [String,Symbol] name of the method
      # @param block   [Proc] block with code to be added as method
      # @param options [Hash] Options of construction
      # @option options cached [Boolean] Flag telling to create
      #   a method with cache
      def initialize(name, **options, &block)
        @block = block
        super(name, **options)
      end

      def build(klass)
        klass.send(:define_method, name, method_block)
      end

      private

      # @private
      #
      # Returns the block that will be used for method creattion
      #
      # @return [Proc]
      def method_block
        return block unless cached?

        cached_method_proc(name, block)
      end

      def cached_method_proc(method_name, inner_block)
        proc do
          instance_variable_get("@#{method_name}") ||
            instance_variable_set(
              "@#{method_name}",
              instance_eval(&inner_block)
            )
        end
      end
    end
  end
end
