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
      def self.parameters_from(*args, &block)
        new(*args, &block).to_s
      end

      private_class_method :new

      attr_reader :extra, :map_block

      # @param parameters_list [Array<Object>] list of parameters and defaults
      # @param extra [String] string to be added to the param name
      def initialize(parameters_list, extra: '', &map_block)
        @parameters_list = parameters_list
        @extra           = extra
        @map_block       = map_block
      end

      def to_s
        parameters_strings + defaults_strings
      end

      private

      def parameters
        parameters_list.reject do |param|
          param.is_a?(Hash)
        end
      end

      def defaults
        parameters_list.select do |param|
          param.is_a?(Hash)
        end.reduce(&:merge) || {}
      end

      def parameters_strings
        parameters.map do |param|
          "#{param}#{extra}"
        end
      end

      def defaults_strings
        defaults.map(&map_block)
      end

      def parameters_list
        @parameters_list ||= []
      end
    end
  end
end
