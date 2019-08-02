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

      # Adds the instance method to given klass
      #
      # @param klass [Class] class which will receive the new method
      #
      # @see MethodDefinition#build
      #
      # @return [Symbol] name of the created method
      #
      # @example Using instance block method with cached options
      #   class MyModel
      #   end
      #
      #   instance = MyModel.new
      #
      #   method_definition = Sinclair::MethodDefinition::InstanceBlockDefinition.new(
      #     :sequence, cached: true
      #   ) do
      #     @x = @x.to_i ** 2 + 1
      #   end
      #
      #   method_definition.build(MyModel) # adds instance_method :sequence to
      #                                    # MyModel instances
      #
      #   instance.instance_variable_get(:@sequence) # returns nil
      #   instance.instance_variable_get(:@x)        # returns nil
      #
      #   instance.sequence               # returns 1
      #   instance.sequence               # returns 1 (cached value)
      #
      #   instance.instance_variable_get(:@sequence) # returns 1
      #   instance.instance_variable_get(:@x)        # returns 1
      #
      # @example Using class block method without options
      #   class MyModel
      #   end
      #
      #   method_definition = Sinclair::MethodDefinition::ClassBlockDefinition.new(:sequence) do
      #     @x = @x.to_i ** 2 + 1
      #   end
      #
      #   method_definition.build(MyModel)    # adds instance_method :sequence to
      #                                       # MyModel instances
      #
      #   MyModel.instance_variable_get(:@x) # returns nil
      #
      #   MyModel.sequence                   # returns 1
      #   MyModel.sequence                   # returns 2
      #   MyModel.sequence                   # returns 5
      #
      #   MyModel.instance_variable_get(:@x) # returns 5
      def build(klass)
        klass.send(method_definer, name, method_block)
      end

      private

      # @method block
      # @private
      #
      # Block with code to be added as method
      # @return [Proc]
      attr_reader :block

      # @private
      #
      # Returns the block that will be used for method creattion
      #
      # @return [Proc]
      def method_block
        return block unless cached?

        case cached
        when :full
          full_cached_method_proc(name, block)
        else
          cached_method_proc(name, block)
        end
      end

      # @private
      #
      # Returns proc block when {#cached?} as simple
      #
      # @return [Proc]
      def cached_method_proc(method_name, inner_block)
        proc do
          instance_variable_get("@#{method_name}") ||
            instance_variable_set(
              "@#{method_name}",
              instance_eval(&inner_block)
            )
        end
      end

      # @private
      #
      # Returns proc block when {#cached?} as full
      #
      # @return [Proc]
      def full_cached_method_proc(method_name, inner_block)
        proc do
          if instance_variable_defined?("@#{method_name}")
            instance_variable_get("@#{method_name}")
          else
            instance_variable_set(
              "@#{method_name}",
              instance_eval(&inner_block)
            )
          end
        end
      end
    end
  end
end
