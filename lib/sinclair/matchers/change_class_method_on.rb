# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # Checks if a class method was changed
    # by the call of a block
    #
    #  This is used with a RSpec DSL method
    #  change_class_method(method_name).on(class_object)
    class ChangeClassMethodOn < ChangeMethodOn
      # @param [Class] klass
      #   Class where the class method should be added to
      #
      # @param method_name [SYmbol,String] method name
      def initialize(target, method_name)
        @klass = target
        super(method_name)
      end

      # Return expectaton description
      #
      # @return [String]
      def description
        "change class method '#{method_name}' on #{klass}"
      end

      # Returns message on expectation failure
      #
      # @return [String]
      def failure_message_for_should
        "expected class method '#{method_name}' to be changed on #{klass} but " \
          "#{initial_state ? "it didn't" : "it didn't exist"}"
      end

      # Returns message on expectation failure for negative expectation
      #
      # @return [String]
      def failure_message_for_should_not
        "expected class method '#{method_name}' not to be changed on #{klass} but it was"
      end

      private

      # Checks if class has instance method defined
      #
      # @return [Boolean]
      def state
        klass.methods(false).include?(method_name.to_sym) \
          && klass.method(method_name)
      end

      # Raises when block was not given
      #
      # @raise SyntaxError
      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the `change_class_method_on` matcher. ' \
          'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end
