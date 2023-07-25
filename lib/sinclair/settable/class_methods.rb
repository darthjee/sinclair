# frozen_string_literal: true

class Sinclair
  module Settable
    module ClassMethods
      def read_with(&read_block)
        @read_block = (read_block || @read_block)
      end
    end
  end
end
