# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # Checks if a method was changed
    # by the call of a block
    #
    #  This is used with a RSpec DSL method
    #  change_method(method_name).on(class_object)
    class ChangeInstanceMethodOn < ChangeMethodOn
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
        "change method '#{method_name}' on #{klass} instances"
      end

      # Returns message on expectation failure
      #
      # @return [String]
      def failure_message_for_should
        "expected '#{method_name}' to be changed on #{klass} but " \
          "#{initial_state ? "it didn't" : "it didn't exist"}"
      end

      # Returns message on expectation failure for negative expectation
      #
      # @return [String]
      def failure_message_for_should_not
        "expected '#{method_name}' not to be changed on #{klass} but it was"
      end

      protected

      # @method instance
      # @api private
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
        klass.method_defined?(method_name) &&
          klass.instance_method(method_name)
      end

      # @private
      #
      # Raises when block was not given
      #
      # @raise SyntaxError
      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the `change_instance_method_on` matcher. ' \
          'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end
