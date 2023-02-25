# frozen_string_literal: true

class Sinclair
  class DummyClassBuilder < Sinclair
    def init
      add_class_method(:blocked) { 1 }
      add_class_method(:defined, "@value = value + #{options_object&.increment || 1}")
      add_class_method(:value, '@value ||= 0')
      add_class_method(:type_block, type: :block) { 3 }
      add_class_method(:type_string, '10', type: :string)
      add_class_method(:attr_accessor, :some_attribute, type: :call)
    end
  end
end
