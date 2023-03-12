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

      attr_reader :parameters_list, :addtion, :map_block

      def initialize(parameters_list, addtion='', &map_block)
        @parameters_list = parameters_list || []
        @addtion = addtion
        @map_block = map_block
      end

      def to_s
        parameters_strings + 
        defaults_strings
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
        end.reduce(&:merge) 
      end

      def parameters_strings
        parameters.map do |param|
          "#{param}#{addtion}"
        end
      end

      def defaults_strings
        return [] unless defaults

        defaults.map(&map_block)
      end
    end
  end
end
