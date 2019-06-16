# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # Define a method from string
    class StringDefinition < MethodDefinition
      # @param name    [String,Symbol] name of the method
      # @param code    [String] code to be evaluated as method
      # @param options [Hash] Options of construction
      # @option options cached [Boolean] Flag telling to create
      #   a method with cache
      def initialize(name, code = nil, **options)
        @code = code
        super(name, **options)
      end

      # Adds the method to given klass
      #
      # @param klass [Class] class which will receive the new method
      #
      # @see MethodDefinition#build
      #
      # @return [Symbol] name of the created method
      #
      def build(klass)
        klass.module_eval(code_definition, __FILE__, __LINE__ + 1)
      end

      private

      # @private
      #
      # Builds full code of method
      #
      # @return [String]
      def code_definition
        code_line = cached? ? code_with_cache : code

        <<-CODE
          def #{name}
            #{code_line}
          end
        CODE
      end

      def code_with_cache
        "@#{name} ||= #{code}"
      end
    end
  end
end
