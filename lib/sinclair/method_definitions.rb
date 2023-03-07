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
    def add(*args, type: nil, **options, &block)
      definitions << definition_from(*args, type: type, **options, &block)
    end

    private

    # @private
    #
    # Builds a definition from arguments
    #
    # The type is decided based in the arguments
    #
    # @overload definition_from(definition_class, name, code = nil, **options)
    #   @param name [String,Symbol] method name
    #   @param code [String] code to be evaluated when the method is ran
    #   @param options [Hash] Options of construction
    #   @option options cached [Boolean] Flag telling to create
    #     a method with cache
    #
    # @overload definition_from(definition_class, name, **options, &block)
    #   @param name [String,Symbol] method name
    #   @param options [Hash] Options of construction
    #   @option options cached [Boolean] Flag telling to create
    #     a method with cache
    #   @param block [Proc]  block to be ran as method
    #
    # @overload definition_from(type, *args, **options, &block)
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
    # @return [MethodDefinition]
    # @return [MethodDefinition::BlockDefinition]
    # @return [MethodDefinition::StringDefinition]
    # @return [MethodDefinition::CallDefinition]
    def definition_from(*args, type:, **options, &block)
      return MethodDefinition.from(*args, **options, &block) unless type

      MethodDefinition.for(type, *args, **options, &block)
    end

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
