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
        return '' unless parameters

        plain_parameters = parameters.reject do |param|
          param.is_a?(Hash)
        end

        with_defaults = parameters.select do |param|
          param.is_a?(Hash)
        end.reduce(&:merge) || {}

        with_defaults = with_defaults.map do |key, value|
          "#{key} = #{value}"
        end

        "(#{[plain_parameters + with_defaults].join(', ')})"
      end
    end
  end
end
