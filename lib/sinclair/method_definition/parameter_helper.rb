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
      #   @param joinner [String] string used when joining variable with default value
      #
      # @return [String]
      def self.parameters_from(*args, **opts)
        new(*args, **opts).strings
      end

      private_class_method :new

      attr_reader :extra, :joinner

      # @param parameters_list [Array<Object>] list of parameters and defaults
      # @param extra [String] string to be added to the param name
      def initialize(parameters_list, extra: '', joinner: ' = ')
        @parameters_list = parameters_list
        @extra           = extra
        @joinner = joinner
      end

      def strings
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
        defaults.map do |key, value|
          "#{key}#{joinner}#{value}"
        end
      end

      def parameters_list
        @parameters_list ||= []
      end
    end
  end
end
