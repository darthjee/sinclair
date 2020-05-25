# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    # @abstract
    #
    # Base class for add_method_to matcher
    class AddMethodTo < Base
      # Checks if expectation is true or not
      #
      # @return [Boolean] expectation check
      def matches?(event_proc)
        return false unless event_proc.is_a?(Proc)

        raise_block_syntax_error if block_given?
        perform_change(event_proc)
        added?
      end

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
