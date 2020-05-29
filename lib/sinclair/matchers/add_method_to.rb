# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    # @abstract
    #
    # Base class for add_method_to matcher
    class AddMethodTo < Base
      include MethodTo

      private

      # @private
      #
      # Checks if a method was added (didn't exist before)
      #
      # @return Boolean
      def check
        !@initial_state && @final_state
      end
    end
  end
end
