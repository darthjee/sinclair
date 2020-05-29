# frozen_string_literal: true

class Sinclair
  module Matchers
    class ChangeMethodOn < Base
      include MethodTo

      private

      def check
        @initial_state && @initial_state != @final_state
      end
    end
  end
end

