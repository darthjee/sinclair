# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @abstract
    # @author darthjee
    #
    # Define a method from block
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

      default_value :block?, true
      default_value :string?, false

      # Returns the block that will be used for method creattion
      #
      # @return [Proc]
      def method_block
        return block unless cached?

        case cached
        when :full
          BlockHelper.full_cached_method_proc(name, &block)
        else
          BlockHelper.cached_method_proc(name, &block)
        end
      end

      private

      # @method block
      # @private
      #
      # Block with code to be added as method
      # @return [Proc]
      attr_reader :block
    end
  end
end
