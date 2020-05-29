# frozen_string_literal: true

class Sinclair
  module Matchers
    module MethodTo
      def failure_message
        failure_message_for_should
      end

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

      private

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
