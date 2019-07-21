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
    class AddClassMethodTo < AddMethodTo
      # @param [Class] klass
      #   Class where the class method should be added to
      #
      # @param method [SYmbol,String] method name
      def initialize(klass, method)
        @klass = klass
        super(method)
      end

      # Return expectaton description
      #
      # @return [String]
      def description
        "add method class_method '#{method}' to #{klass}"
      end

      # Returns message on expectation failure
      #
      # @return [String]
      def failure_message_for_should
        "expected class_method '#{method}' to be added to #{klass} but " \
          "#{@initial_state ? 'it already existed' : "it didn't"}"
      end

      # Returns message on expectation failure for negative expectation
      #
      # @return [String]
      def failure_message_for_should_not
        "expected class_method '#{method}' not to be added to #{klass} but it was"
      end

      alias failure_message failure_message_for_should
      alias failure_message_when_negated failure_message_for_should_not

      protected

      # @method klass
      # @private
      #
      # Class where class method should be added to
      #
      # @return [Class]
      attr_reader :klass

      private

      # Checks if class has instance method defined
      #
      # @return [Boolean]
      def method_defined?
        klass.methods(false).include?(method.to_sym)
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
