# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    class AddMethodTo < RSpec::Matchers::BuiltIn::BaseMatcher
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

      protected

      # @method method
      # @private
      #
      # The method, to be checked, name
      #
      # @return [Symbol]
      attr_reader :method

      private

      # @private
      #
      # Checks if a method was added (didn't exist before)
      #
      # @return Boolean
      def added?
        !@initial_state && @final_state
      end

      # @private
      #
      # Call block to check if it aded a method or not
      #
      # @return [Boolan]
      def perform_change(event_proc)
        @initial_state = method_defined?
        event_proc.call
        @final_state = method_defined?
      end
    end
  end
end
