# frozen_string_literal: true

class Sinclair
  # @api private
  # @author darthjee
  #
  # Class responsible for building methods
  class MethodBuilder
    autoload :Base,                'sinclair/method_builder/base'
    autoload :StringMethodBuilder, 'sinclair/method_builder/string_method_builder'
    autoload :BlockMethodBuilder,  'sinclair/method_builder/block_method_builder'

    # @param klass [Class] class to receive the method
    def initialize(klass)
      @klass = klass
    end

    def build_method(*definitions)
      definitions.each do |definition|
        build_from_definition(definition, :instance)
      end
    end

    def build_class_method(*definitions)
      definitions.each do |definition|
        build_from_definition(definition, :class)
      end
    end

    private

    attr_reader :klass

    def build_from_definition(definition, type)
      if definition.string?
        StringMethodBuilder.new(klass, definition, type: type).build
      else
        BlockMethodBuilder.new(klass, definition, type: type).build
      end
    end
  end
end
