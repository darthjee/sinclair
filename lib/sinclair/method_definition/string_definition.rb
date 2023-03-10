# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Define an instance method from string
    class StringDefinition < MethodDefinition
      build_with MethodBuilder::StringMethodBuilder

      # @param name    [String,Symbol] name of the method
      # @param code    [String] code to be evaluated as method
      # @param options [Hash] Options of construction
      # @option options cached [Boolean] Flag telling to create
      #   a method with cache
      def initialize(name, code = nil, **options)
        @code = code
        super(name, **options)
      end

      default_value :block?, false
      default_value :string?, true

      # string with the code to be defined
      #
      # @return [String]
      def code_definition
        <<-CODE
          def #{name}#{parameters_string}
            #{code_line}
          end
        CODE
      end

      private

      def parameters_string
        return '' unless options_object.parameters

        plain_parameters = options_object.parameters.reject do |param|
          param.is_a?(Hash)
        end

        with_defaults = options_object.parameters.select do |param|
          param.is_a?(Hash)
        end.reduce(&:merge) || {}

        with_defaults = with_defaults.map do |key, value|
          "#{key} = #{value}"
        end

        "(#{[plain_parameters + with_defaults].join(', ')})"
      end

      # @private
      # codeline to be run inside the code
      #
      # @return [String]
      def code_line
        cached? ? code_with_cache : code
      end

      # @method code
      # @private
      #
      # Code to be evaluated as method
      #
      # @return [String]
      attr_reader :code

      # @private
      #
      # Returns string code when {#cached?}
      #
      # @return [String]
      def code_with_cache
        case cached
        when :full
          "defined?(@#{name}) ? @#{name} : (@#{name} = #{code})"
        else
          "@#{name} ||= #{code}"
        end
      end
    end
  end
end
