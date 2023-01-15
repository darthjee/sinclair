# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    # @api private
    # @author darthjee
    class Reader < Accessor
      private

      def accessor_type
        :reader
      end
    end
  end
end
