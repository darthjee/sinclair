# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    # @abstract
    #
    # Base class for change_method_on matcher
    class ChangeMethodOn < Base
      include MethodTo

      private

      # @private
      #
      # Checks if a method was changed
      #
      # @return Boolean
      def check
        initial_state && initial_state != final_state
      end
    end
  end
end
