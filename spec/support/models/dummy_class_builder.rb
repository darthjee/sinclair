# frozen_string_literal: true

class Sinclair
  class DummyClassBuilder < Sinclair
    def init
      add_class_method(:blocked) { 1 }
      add_class_method(:defined, "@value = value + #{options_object&.increment || 1}")
      add_class_method(:value, '@value ||= 0')
    end
  end
end
