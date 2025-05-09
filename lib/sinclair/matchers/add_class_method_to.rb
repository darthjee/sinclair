# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddClassMethodTo checks whether a method was
    # or not added to a class by the call of a block
    #
    # This is used with a RSpec DSL method
    # add_class_method(method_name).to(class_object)
    #
    # @example
    #   RSpec.configure do |config|
    #     config.include Sinclair::Matchers
    #   end
    #
    #   class MyModel
    #   end
    #
    #   describe 'my test' do
    #     let(:klass)   { Class.new(MyModel) }
    #
    #     let(:block) do
    #       proc do
    #         klass.define_singleton_method(:parent_name) { superclass.name }
    #       end
    #     end
    #
    #     it do
    #       expect(&block).to add_class_method(:parent_name).to(klass)
    #     end
    #   end
    class AddClassMethodTo < AddMethodTo
      # @param [Class] klass
      #   Class where the class method should be added to
      #
      # @param method_name [SYmbol,String] method name
      def initialize(klass, method_name)
        @klass = klass
        super(method_name)
      end

      # Return expectaton description
      #
      # @return [String]
      def description
        "add class method '#{method_name}' to #{klass}"
      end

      # Returns message on expectation failure
      #
      # @return [String]
      def failure_message_for_should
        "expected class method '#{method_name}' to be added to #{klass} but " \
          "#{initial_state ? 'it already existed' : "it didn't"}"
      end

      # Returns message on expectation failure for negative expectation
      #
      # @return [String]
      def failure_message_for_should_not
        "expected class method '#{method_name}' not to be added to #{klass} but it was"
      end

      private

      # Checks if class has instance method defined
      #
      # @return [Boolean]
      def state
        klass.methods(false).include?(method_name.to_sym)
      end

      # Raises when block was not given
      #
      # @raise SyntaxError
      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the `add_class_method_to` matcher. ' \
                           'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end
