# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    autoload :StringMethodBuilder, 'sinclair/method_builder/string_method_builder'
    autoload :BlockMethodBuilder,  'sinclair/method_builder/block_method_builder'

    def initialize(klass)
      @klass = klass
    end

    def build_method(*definitions)
      definitions.each do |definition|
        if definition.string?
          StringMethodBuilder.new(klass, definition).build
        else
          BlockMethodBuilder.new(klass, definition).build
        end
      end
    end

    def build_class_method(*definitions)
      definitions.each do |definition|
        if definition.string?
          StringMethodBuilder.new(klass, definition, type: :class).build
        else
          BlockMethodBuilder.new(klass, definition, type: :class).build
        end
      end
    end

    private

    attr_reader :klass
  end
end
