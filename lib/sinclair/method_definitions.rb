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
    # The type is decided based in the arguments
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
    # @return [Array<MethodDefinition>]
    def add(name, code = nil, **options, &block)
      definitions << MethodDefinition.from(name, code, **options, &block)
    end

    # Builds and adds new definition
    #
    # The type is decided based on the argument +type+
    #
    # @param type [Symbol] type of definition
    #   - :string -> {MethodDefinition::StringDefinition}
    #   - :block -> {MethodDefinition::BlockDefinition}
    #   - :call -> {MethodDefinition::CallDefinition}
    # @param options [Hash] Options of construction
    # @option options cached [Boolean] Flag telling to create
    #   a method with cache
    # @param block [Proc]  block to be ran as method
    #
    # @return [Array<MethodDefinition>]
    def add_definition(type, *args, **options, &block)
      definitions << MethodDefinition.for(type, *args, **options, &block)
    end

    private

    # @private
    #
    # All definitions
    #
    # @return [Array<MethodDefinition>]
    def definitions
      @definitions ||= []
    end
  end
end
