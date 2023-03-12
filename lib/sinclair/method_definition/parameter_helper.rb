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
        # Maps an array of parameters into an Array of +Strings+
        #
        # The code takes advantage of ruby splitting parameters and named
        # parameters (_defaults) from a list of arguments on method call
        #
        # @return [Array<String>]
        def parameters_for(*parameters, **_defaults, &block)
          return [] unless parameters

          parameters.map(&block)
        end

        # Maps a hash of defaults parameters into an Array of +Strings+
        #
        # The code takes advantage of ruby splitting parameters and named
        # parameters (_defaults) from a list of arguments on method call
        #
        # @return [Array<String>]
        def parameteres_defaults_for(*_parameters, **defaults, &block)
          return [] unless defaults

          defaults.map(&block)
        end
      end
    end
  end
end
