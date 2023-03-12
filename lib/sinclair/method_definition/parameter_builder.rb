# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Builder a string of parameters
    #
    # This is used when creating the string for a method defined
    # using a string definition
    #
    # @see StringDefinition
    class ParameterBuilder
      # Builds a string representing method parameters
      #
      # @overload from(parameters, named_parameters)
      #   @param parameters [Array<Object>] List of parameters.
      #   @param named_parameters [Array<Object>] List of named parameters
      #
      #   The list of +parameters+/+named_parameters+ is formed by an
      #   array of +String+/+Symbol+ representing required parameters
      #   and +Hash+ representing parameters with default values
      #
      # @return [String]
      def self.from(*args)
        new(*args).to_s
      end

      private_class_method :new

      # @param parameters [Array<Object>] List of parameters.
      # @param named_parameters [Array<Object>] List of named parameters
      def initialize(parameters, named_parameters)
        @parameters       = parameters
        @named_parameters = named_parameters
      end

      # Returns the parameters string
      #
      # @return [String]
      def to_s
        return '' if empty_parameters?

        "(#{parameters_string})"
      end

      private

      attr_reader :parameters, :named_parameters

      # @!method parameters
      # @api private
      # @private
      #
      # List of parameters.
      #
      # @return [Array<Object>]

      # @!method named_parameters
      # @api private
      # @private
      #
      # List of named parameters
      #
      # @return [Array<Object>]

      delegate :parameters_for, :parameteres_defaults_for, to: ParameterHelper

      # @private
      # Flag if any kind of parameters have not been provided
      #
      # @return [TrueClass,FalseClass]
      def empty_parameters?
        !parameters.present? && !named_parameters.present?
      end

      def parameters_string
        (
          parameters_strings +
          parameters_with_defaults +
          named_parameters_strings +
          named_parameters_with_defaults
        ).join(', ')
      end

      def parameters_strings
        parameters_for(parameters, &:to_s)
      end

      def named_parameters_strings
        parameters_for(named_parameters) do |param|
          "#{param}:"
        end
      end

      def parameters_with_defaults
        parameteres_defaults_for(parameters) do |key, value|
          "#{key} = #{value}"
        end
      end

      def named_parameters_with_defaults
        parameteres_defaults_for(named_parameters) do |key, value|
          "#{key}: #{value}"
        end
      end
    end
  end
end
