# frozen_string_literal: true

class Sinclair
  # Enumerator holding all method definitions
  class MethodDefinitions < Array
    # Builds and adds new definition
    def add(definition_class, name, code = nil, **options, &block)
      self << definition_class.from(name, code, **options, &block)
    end
  end
end
