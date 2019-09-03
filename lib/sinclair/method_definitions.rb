# frozen_string_literal: true

class Sinclair
  # @api private
  # @author darthjee
  #
  # Enumerator holding all method definitions
  class MethodDefinitions
    delegate :each, to: :definitions

    # Builds and adds new definition
    #
    # @param name [String,Symbol] method name
    # @param options [Hash] Options of construction
    # @option options cached [Boolean] Flag telling to create
    #   a method with cache
    #
    # @overload add(definition_class, name, code = nil, **options)
    #   @param code [String] code to be evaluated when the method is ran
    #
    # @overload add(definition_class, name, **options, &block)
    #   @param block [Proc]  block to be ran as method
    #
    # @return MethodDefinitions
    def add(name, code = nil, **options, &block)
      definitions << MethodDefinition.from(name, code, **options, &block)
    end

    # All definitions
    #
    # @return [Array<MethodDefinition::Base]
    def definitions
      @definitions ||= []
    end
  end
end
