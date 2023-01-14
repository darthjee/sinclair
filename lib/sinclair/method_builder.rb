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
    autoload :Reader,              'sinclair/method_builder/reader'
    autoload :Writer,              'sinclair/method_builder/writer'

    CLASS_METHOD = :class
    INSTANCE_METHOD = :instance

    # @param klass [Class] class to receive the method
    def initialize(klass)
      @klass = klass
    end

    # Builds methods
    #
    # @param definitions [MethodDefinitions] all methods
    #   definitions to be built
    # @param type [Symbol] type of method to be built
    #
    # @return [MethodDefinitions]
    def build_methods(definitions, type)
      definitions.each do |definition|
        build_from_definition(definition, type)
      end
    end

    private

    attr_reader :klass
    # @method klass
    # @private
    # @api private
    #
    # class to receive the method
    #
    # @return [Class]

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
