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

    autoload :CallMethodBuilder, 'sinclair/method_builder/call_method_builder'

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
    #   - {CLASS_METHOD} : A class method will be built
    #   - {INSTANCE_METHOD} : An instance method will be built
    #
    # @return [MethodDefinitions]
    def build_methods(definitions, type)
      definitions.each do |definition|
        definition.build(klass, type)
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
  end
end
