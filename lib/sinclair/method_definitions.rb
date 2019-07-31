# frozen_string_literal: true

class Sinclair
  class MethodDefinitions
    delegate :each, to: :definitions

    def add(definition_class, name, code = nil, **options, &block)
      definitions << definition_class.from(name, code, **options, &block)
    end

    private

    # @private
    #
    # @api private
    #
    # List of mthod definitions
    #
    # @return [Array<MethodDefinition>]
    def definitions
      @definitions ||= []
    end
  end
end
