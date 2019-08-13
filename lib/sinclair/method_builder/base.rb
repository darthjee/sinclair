# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    # @api private
    # @author darthjee
    #
    # Base class responsible for building methods
    class Base
      # @param klass [Class] class to receive the method
      # @param definition [MethodDefinition] method defined
      # @param type [Symbol] type of method to be build
      #   - +:instance+ instance methods
      #   - +:class+ class methods
      def initialize(klass, definition, type:)
        @klass = klass
        @definition = definition
        @type = type
      end

      private

      attr_reader :klass, :definition, :type

      def instance?
        type == INSTANCE_METHOD
      end
    end
  end
end
