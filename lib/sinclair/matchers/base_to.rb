# frozen_string_literal: true

class Sinclair
  module Matchers
    class BaseTo < Base
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
        @initial_state = method_defined?
        event_proc.call
        @final_state = method_defined?
      end
    end
  end
end

