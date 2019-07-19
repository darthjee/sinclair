# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # Define a method from block
    class InstanceBlockDefinition < BlockDefinition
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
      def build(klass)
        klass.send(:define_method, name, method_block)
      end
    end
  end
end
