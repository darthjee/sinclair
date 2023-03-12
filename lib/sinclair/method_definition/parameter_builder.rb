# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    class ParameterBuilder
      attr_reader :parameters

      def self.from(parameters)
        new(parameters).parameters_string
      end

      def initialize(parameters)
        @parameters = parameters
      end

      def parameters_string
        return '' unless parameters.present?

        "(#{parameters_strings.join(', ')})"
      end

      private

      def parameters_strings
        plain_parameters +
          parameters_with_defaults
      end

      def parameters_with_defaults
        defaults = parameters.select do |param|
          param.is_a?(Hash)
        end.reduce(&:merge)

        return [] unless defaults

        defaults.map do |key, value|
          "#{key} = #{value}"
        end
      end

      def plain_parameters
        parameters.reject do |param|
          param.is_a?(Hash)
        end
      end
    end
  end
end
