# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Define a call of method to e done within the class
    class CallDefinition < MethodDefinition
      build_with MethodBuilder::CallMethodBuilder

      # @param method_name [Symbol] method to be called
      # @param arguments [Array<Symbol,String>] parameters to be passed as
      #   arguments to the call
      def initialize(method_name, *arguments)
        @arguments = arguments
        super(method_name)
      end

      default_value :block?, false
      default_value :string?, false

      def code_block
        method_name = name
        args = arguments

        proc do
          send(method_name, *args)
        end
      end

      private

      attr_reader :arguments
    end
  end
end
