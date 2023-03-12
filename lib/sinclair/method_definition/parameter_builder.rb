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
      def self.from(*args)
        new(*args).parameters_string
      end

      private_class_method :new

      def initialize(parameters, named_parameters)
        @parameters       = parameters
        @named_parameters = named_parameters
      end

      def parameters_string
        return '' unless parameters?

        "(#{parameters_strings.join(', ')})"
      end

      private

      attr_reader :parameters, :named_parameters
      delegate :parameters_for, :parameteres_defaults_for, to: ParameterHelper

      def parameters?
        parameters.present? || named_parameters.present?
      end

      def parameters_strings
        plain_parameters +
          parameters_with_defaults +
          plain_named_parameters +
          named_parameters_with_defaults
      end

      def plain_parameters
        parameters_for(parameters, &:to_s)
      end

      def plain_named_parameters
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
