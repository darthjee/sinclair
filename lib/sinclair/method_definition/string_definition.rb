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

      # codeline to be run inside the code
      #
      # @return [String]
      def code_line
        cached? ? code_with_cache : code
      end

      # string with the code to be defined
      #
      # @return [String]
      def code_definition
        <<-CODE
          def #{name}
            #{code_line}
          end
        CODE
      end

      private

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
