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
      delegate :parameters_from, to: ParameterHelper

      # Builds a string representing method parameters
      #
      # @overload from(parameters, named_parameters)
      #   @param parameters [Array<Object>] List of parameters.
      #   @param named_parameters [Array<Object>] List of named parameters
      #
      #   The list of +parameters+/+named_parameters+ is formed by an
      #   array of +Symbol+ representing required parameters
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
      # List of parameters
      #
      # @return [Array<Object>]

      # @!method named_parameters
      # @api private
      # @private
      #
      # List of named parameters
      #
      # @return [Array<Object>]

      # @private
      # Flag if any kind of parameters have not been provided
      #
      # @return [TrueClass,FalseClass]
      def empty_parameters?
        !parameters.present? && !named_parameters.present?
      end

      # String of parameters witout ()
      #
      # This will join all individual parameters strings by +,+
      #
      # @return [String]
      def parameters_string
        (
          parameters_from(parameters) { |key, value| "#{key} = #{value}" } +
          parameters_from(named_parameters, extra: ':') { |key, value| "#{key}: #{value}" }
        ).join(', ')
      end
    end
  end
end
