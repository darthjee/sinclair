# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Define a call of method to e done within the class
    class NewCallDefinition < MethodDefinition
      build_with MethodBuilder::NewCallMethodBuilder

      # @param method_name [Symbol] method to be called
      # @param arguments [Array<Symbol,String>] parameters to be passed as
      #   arguments to the call
      def initialize(method_name, *arguments)
        @arguments = arguments
        super(method_name)
      end

      default_value :block?, false
      default_value :string?, false

      # String to be executed within the class
      # @return [String]
      def code_string
        "#{name} :#{arguments.join(', :')}"
      end

      # String to be executed within the class running code to change the class itself
      #
      # @see code_string
      # @return [String]
      def class_code_string
        <<-CODE
          class << self
            #{code_string}
          end
        CODE
      end

      private

      attr_reader :arguments

      # @method arguments
      # @api private
      # @private
      #
      # parameters to be passed as arguments to the call
      #
      # @return [Array<Symbol,String>]
    end
  end
end
