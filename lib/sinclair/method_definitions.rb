# frozen_string_literal: true

class Sinclair
  class MethodDefinitions < Array
    def add(definition_class, name, code = nil, **options, &block)
      self << definition_class.from(name, code, **options, &block)
    end
  end
end
