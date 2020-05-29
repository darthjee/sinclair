# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    #
    # Common methods on final matchers
    module MethodTo
      # Used for other versions of rspec
      #
      # Some versions call failure_message, others
      # call failure_message_for_should
      #
      # @return [String]
      def failure_message
        failure_message_for_should
      end

      # Used for other versions of rspec
      #
      # Some versions call failure_message_when_negated, others
      # call failure_message_for_should_not
      #
      # @return [String]
      def failure_message_when_negated
        failure_message_for_should_not
      end

      # Checks if expectation is true or not
      #
      # @return [Boolean] expectation check
      def matches?(event_proc)
        return false unless event_proc.is_a?(Proc)

        raise_block_syntax_error if block_given?
        perform_change(event_proc)
        check
      end

      protected

      # @method klass
      # @api private
      # @private
      #
      # Class where class method should be added to
      #
      # @return [Class]
      attr_reader :klass

      private

      # @method initial_state
      # @api private
      # @private
      #
      # State before running the block
      #
      # @return [Object]

      # @method final_state
      # @api private
      # @private
      #
      # State after running the block
      #
      # @return [Object]
      attr_reader :initial_state, :final_state

      # @private
      #
      # Call block to check if it aded a method or not
      #
      # @return [Boolan]
      def perform_change(event_proc)
        @initial_state = state
        event_proc.call
        @final_state = state
      end
    end
  end
end
