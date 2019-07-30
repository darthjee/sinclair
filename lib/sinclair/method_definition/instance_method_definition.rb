# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    module InstanceMethodDefinition
      def self.from(name, code = nil, **options, &block)
        if block
          InstanceBlockDefinition.new(name, **options, &block)
        else
          InstanceStringDefinition.new(name, code, **options)
        end
      end
    end
  end
end
