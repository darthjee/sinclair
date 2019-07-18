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
    class AddClassMethodTo < RSpec::Matchers::BuiltIn::BaseMatcher
      # @param [Class] klass
      #   class where the method should be added to
      #
      # @param method [SYmbol,String] method name
      def initialize(target, method)
        @klass = target
        @method = method
      end

      # Returnst expectaton description
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

      # Checks if expectation is true or not
      #
      # @return [Boolean] expectation check
      def matches?(event_proc)
        return false unless event_proc.is_a?(Proc)
        raise_block_syntax_error if block_given?
        perform_change(event_proc)
        added?
      end

      # definition needed for block matchers
      def supports_block_expectations?
        true
      end

      # Checkes if another instnce is equal self
      #
      # @return [Boolean]
      def equal?(other)
        return unless other.class == self.class
        other.method == method &&
          other.klass == klass
      end

      alias == equal?
      alias failure_message failure_message_for_should
      alias failure_message_when_negated failure_message_for_should_not

      protected

      # @private
      attr_reader :method, :klass

      private

      # Checks if a method was added (didn't exist before)
      #
      # @return Boolean
      def added?
        !@initial_state && @final_state
      end

      # Call block to check if it aded a method or not
      #
      # @return [Boolan]
      def perform_change(event_proc)
        @initial_state = method_defined?
        event_proc.call
        @final_state = method_defined?
      end

      # Checks if class has instance method defined
      #
      # @return [Boolean]
      def method_defined?
        klass.method_defined?(method)
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

