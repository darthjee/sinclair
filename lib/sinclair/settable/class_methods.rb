# frozen_string_literal: true

class Sinclair
  module Settable
    module ClassMethods
      def read_with(&read_block)
        return @read_block = read_block if read_block
        return @read_block if @read_block

        superclass_settable&.read_with
      end

      def superclass_settable
        included_modules.find do |modu|
          modu <= Sinclair::Settable
        end
      end
    end
  end
end
