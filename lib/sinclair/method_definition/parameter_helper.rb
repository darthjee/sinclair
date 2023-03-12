# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Helper containing helepr methods for remapping parameters
    #
    # @see ParameterBuilder
    module ParameterHelper
      class << self
        def parameters_for(*parameters, **_defaults, &block)
          return [] unless parameters

          parameters.map(&block)
        end

        def parameteres_defaults_for(*_parameters, **defaults, &block)
          return [] unless defaults

          defaults.map(&block)
        end
      end
    end
  end
end
