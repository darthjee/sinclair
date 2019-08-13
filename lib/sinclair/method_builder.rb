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

    CLASS_METHOD = :class
    INSTANCE_METHOD = :instance

    # @param klass [Class] class to receive the method
    def initialize(klass)
      @klass = klass
    end

    # Builds instance methods on klass
    #
    # @param definitions [Array<MethodDefinition>] all methods
    #   definitions to be built
    #
    # @return [Array<MethodDefinition>]
    def build_method(*definitions)
      definitions.each do |definition|
        build_from_definition(definition, INSTANCE_METHOD)
      end
    end

    # Builds class methods on klass
    #
    # @param definitions [Array<MethodDefinition>] all methods
    #   definitions to be built
    #
    # @return [Array<MethodDefinition>]
    def build_class_method(*definitions)
      definitions.each do |definition|
        build_from_definition(definition, CLASS_METHOD)
      end
    end

    private

    attr_reader :klass

    # @private
    #
    # Build one method from definition
    #
    # @param definition [MethodDefinition] the method definition
    # @param type [Symbol] type of method to be built
    #
    # @return (see Base#build)
    def build_from_definition(definition, type)
      if definition.string?
        StringMethodBuilder.new(klass, definition, type: type).build
      else
        BlockMethodBuilder.new(klass, definition, type: type).build
      end
    end
  end
end
