# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddInstanceMethodTo checks whether a method was or not added by the call of a block
    #
    # This is used with a RSpec DSL method add_method(method_name).to(class_object)
    #
    # @example
    #   RSpec.configure do |config|
    #     config.include Sinclair::Matchers
    #   end
    #
    #   class MyModel
    #   end
    #
    #   RSpec.describe 'my test' do
    #     let(:klass)   { Class.new(MyModel) }
    #     let(:builder) { Sinclair.new(klass) }
    #
    #     before do
    #       builder.add_method(:class_name, 'self.class.name')
    #     end
    #
    #     it do
    #       expect { builder.build }.to add_method(:class_name).to(klass)
    #     end
    #   end
    class AddInstanceMethodTo < AddMethodTo
      # Returns a new instance of AddInstanceMethodTo
      #
      # @overload initialize(klass, method_name)
      #   @param [Class] klass
      #     class where the method should be added to
      #
      # @overload initialize(instance, method_name)
      #   @param [Object] instance
      #     instance of the class where the method should be added to
      #
      # @param method_name [Symbol,String] method name
      def initialize(target, method_name)
        if target.is_a?(Class)
          @klass = target
        else
          @instance = target
        end
        super(method_name)
      end

      # Returnst expectaton description
      #
      # @return [String]
      def description
        "add method '#{method_name}' to #{klass} instances"
      end

      # Returns message on expectation failure
      #
      # @return [String]
      def failure_message_for_should
        "expected '#{method_name}' to be added to #{klass} but " \
          "#{initial_state ? 'it already existed' : "it didn't"}"
      end

      # Returns message on expectation failure for negative expectation
      #
      # @return [String]
      def failure_message_for_should_not
        "expected '#{method_name}' not to be added to #{klass} but it was"
      end

      protected

      # @method instance
      # @private
      #
      # Instance of the class where the method should be added
      #
      # @return [Object]
      attr_reader :instance

      # @private
      #
      # Class to be analised
      #
      # @return [Class]
      def klass
        @klass ||= instance.class
      end

      private

      # @private
      #
      # Checks if class has instance method defined
      #
      # @return [Boolean]
      def state
        klass.method_defined?(method_name)
      end

      # @private
      #
      # Raises when block was not given
      #
      # @raise SyntaxError
      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the `add_instance_method_to` matcher. ' \
          'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end
