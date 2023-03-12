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
        def parameters_for(parameters, &block)
          return [] unless parameters

          parameters.reject do |param|
            param.is_a?(Hash)
          end.map(&block)
        end

        def parameteres_defaults_for(parameters, &block)
          return [] unless parameters

          defaults = parameters.select do |param|
            param.is_a?(Hash)
          end.reduce(&:merge)

          return [] unless defaults

          defaults.map(&block)
        end
      end
    end
  end
end
