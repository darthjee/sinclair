# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    module ClassMethodDefinition
      def self.from(name, code = nil, **options, &block)
        if block
          ClassBlockDefinition.new(name, **options, &block)
        else
          ClassStringDefinition.new(name, code, **options)
        end
      end
    end
  end
end
