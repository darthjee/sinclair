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
    # @overload add(definition_class, name, code = nil, **options)
    #   @param name [String,Symbol] method name
    #   @param code [String] code to be evaluated when the method is ran
    #   @param options [Hash] Options of construction
    #   @option options cached [Boolean] Flag telling to create
    #     a method with cache
    #
    # @overload add(definition_class, name, **options, &block)
    #   @param name [String,Symbol] method name
    #   @param options [Hash] Options of construction
    #   @option options cached [Boolean] Flag telling to create
    #     a method with cache
    #   @param block [Proc]  block to be ran as method
    #
    # @overload add(type, *args, **options, &block)
    #   @param type [Symbol] type of definition
    #     - :string -> {MethodDefinition::StringDefinition}
    #     - :block -> {MethodDefinition::BlockDefinition}
    #     - :call -> {MethodDefinition::CallDefinition}
    #   @param options [Hash] Options of construction
    #   @option options cached [Boolean] Flag telling to create
    #     a method with cache
    #   @param block [Proc]  block to be ran as method
    #
    # @see MethodDefinition.for
    # @see MethodDefinition.from
    #
    # @return [Array<MethodDefinition>]
    def add(*, type: nil, **, &)
      definitions << MethodDefinition.for(type, *, **, &)
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
