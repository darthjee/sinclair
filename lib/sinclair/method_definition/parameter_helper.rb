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
      # @overload parameters_from(parameters_list, named: false)
      #   @param parameters_list [Array<Object>] list of parameters and defaults
      #   @param named [TrueClass,FalseClass] Flag informing if the parameters are
      #     named parameters
      #
      # @return [String]
      def self.parameters_from(*, **)
        new(*, **).strings
      end

      private_class_method :new

      # @param parameters_list [Array<Object>] list of parameters and defaults
      # @param named [TrueClass,FalseClass] Flag informing if the parameters are
      #   named parameters
      def initialize(parameters_list, named: nil)
        @parameters_list = parameters_list
        @named           = named
      end

      # All parameters converted into strings
      #
      # The strings are ready to be pushed into a method definition
      # and joined by +,+
      #
      # @return [Array<String>]
      def strings
        return [] unless parameters_list

        parameters_strings + defaults_strings + wild_card_parameters
      end

      private

      delegate :value_string, to: Stringifier
      attr_reader :parameters_list, :named
      alias named? named

      # @!method parameters_list
      # @api private
      # @private
      #
      # List of parameters and parameters with defaults
      #
      # @return [Array<Object>]

      # @!method named
      # @api private
      # @private
      #
      # Flag informing if the parameters are named parameters
      #
      # @return [TrueClass,FalseClass]

      # @!method named?
      # @api private
      # @private
      #
      # Flag informing if the parameters are named parameters
      #
      # @return [TrueClass,FalseClass]

      # Parameters without defaults
      #
      # These are filtered out from {#parameters_list} where they are not
      # of type +Hash+
      #
      # @return [Array<Symbol>]
      def parameters
        parameters_list.reject do |param|
          param.is_a?(Hash) || param.to_s.match?(/^\*/)
        end
      end

      # Returns the named parameters that have not been defined
      #
      # THis is usually extra options
      #
      # @return [Array<String>]
      def wild_card_parameters
        parameters_list.reject do |param|
          param.is_a?(Hash) || !param.to_s.match?(/^\*/)
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
        return parameters.map(&:to_s) unless named?

        parameters.map do |param|
          "#{param}:"
        end
      end

      # Strings representing all parameters with default value
      #
      # @return [Array<String>]
      def defaults_strings
        defaults.map do |parameter, value|
          default_string(parameter, value)
        end
      end

      # Returns the string for one default parameter
      #
      # @param parameter [Symbol] name of the parameter
      # @param value [Object] default value
      #
      # @return [String]
      def default_string(parameter, value)
        "#{parameter}#{joinner}#{value_string(value)}"
      end

      # Returns the string used when joining a parameter with it's default value
      #
      # @see #named?
      #
      # @return [String]
      def joinner
        @joinner ||= named? ? ': ' : ' = '
      end
    end
  end
end
