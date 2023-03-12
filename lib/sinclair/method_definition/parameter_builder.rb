# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    class ParameterBuilder
      attr_reader :parameters

      class << self
        def from(parameters)
          new(parameters).parameters_string
        end

        def plain_parameters(parameters, &block)
          parameters.reject do |param|
            param.is_a?(Hash)
          end.map(&block)
        end

        def parameters_with_defaults(parameters, &block)
          defaults = parameters.select do |param|
            param.is_a?(Hash)
          end.reduce(&:merge)

          return [] unless defaults

          defaults.map(&block)
        end
      end

      private_class_method :new

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
        self.class.parameters_with_defaults(parameters) do |key, value|
          "#{key} = #{value}"
        end
      end

      def plain_parameters
        self.class.plain_parameters(parameters, &:to_s)
      end
    end
  end
end
