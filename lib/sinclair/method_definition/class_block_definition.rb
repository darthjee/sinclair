# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # Define an class method from block
    class ClassBlockDefinition < BlockDefinition
      # Adds the class method to given klass
      #
      # @param klass [Class] class which will receive the new
      #   class method
      #
      # @see MethodDefinition#build
      #
      # @return [Symbol] name of the created method
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
        klass.send(:define_singleton_method, name, method_block)
      end
    end
  end
end
