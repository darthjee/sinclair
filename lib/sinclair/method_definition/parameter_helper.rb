# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Helper containing helepr methods for remapping parameters
    #
    # @see ParameterBuilder
    class ParameterHelper
      # Returns a list of strings of parameters
      #
      # @overload parameters_from(parameters_list, extra: '', joinner: ' = ')
      #   @param parameters_list [Array<Object>] list of parameters and defaults
      #   @param extra [String] string to be added to the param name
      #     (eg: +:+ for named parameters)
      #   @param joinner [String] string used when joining variable with default value
      #
      # @return [String]
      def self.parameters_from(*args, **opts)
        new(*args, **opts).strings
      end

      private_class_method :new

      # @param parameters_list [Array<Object>] list of parameters and defaults
      # @param extra [String] string to be added to the param name
      def initialize(parameters_list, extra: nil, joinner: ' = ')
        @parameters_list = parameters_list
        @extra           = extra
        @joinner         = joinner
      end

      # All parameters converted into strings
      #
      # The strings are ready to be pushed into a method definition
      # and joined by +,+
      #
      # @return [Array<String>]
      def strings
        return [] unless parameters_list

        parameters_strings + defaults_strings
      end

      # private

      attr_reader :parameters_list, :extra, :joinner

      # @!method parameters_list
      # @api private
      # @private
      #
      # List of parameters and parameters with defaults
      #
      # @return [Array<Object>]

      # @!method extra
      # @api private
      # @private
      #
      # String to be added when defining parameters without default value
      #
      # When a parameter is named, +:+ is added, when it is not, nothing is
      # added
      #
      # @return [String]

      # Parameters without defaults
      #
      # These are filtered out from {#parameters_list} where they are not
      # of type +Hash+
      #
      # @return [Array<Symbol>]
      def parameters
        parameters_list.reject do |param|
          param.is_a?(Hash)
        end
      end

      # Hash representing all parameters with default values
      #
      # These are filtered out from {#parameters_list} where they are
      # of type +Hash+ and merged into a single hash
      #
      # @return [Hash]
      def defaults
        parameters_list.select do |param|
          param.is_a?(Hash)
        end.reduce(&:merge) || {}
      end

      # Parameters without default converted to final string
      #
      # {#extra} is added so that for normal parameters the parameter is returned
      # and for named parameter +:+ is added
      #
      # @return [Array<String>]
      def parameters_strings
        parameters.map do |param|
          "#{param}#{extra}"
        end
      end

      # Strings representing all parameters with default value
      #
      # @return [Array<String>]
      def defaults_strings
        defaults.map do |key, value|
          "#{key}#{joinner}#{value}"
        end
      end
    end
  end
end
