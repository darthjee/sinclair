# frozen_string_literal: true

class Sinclair
  class DummyBuilder < Sinclair
    def init
      add_method(:blocked) { 1 }
      add_method(:defined, "@value = value + #{options_object&.increment || 1}")
      add_method(:value, cached: true) { 0 }
      add_method(:type_block, type: :block) { 3 }
      add_method(:type_string, "10", type: :string)
      add_method(:attr_accessor, :some_attribute, type: :call)
    end
  end
end
