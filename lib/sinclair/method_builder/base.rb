# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    # @api private
    # @author darthjee
    #
    # Base class responsible for building methods
    class Base
      def initialize(klass, definition, type: :instance)
        @klass = klass
        @definition = definition
        @type = type
      end

      private

      attr_reader :klass, :definition, :type

      def instance?
        type == :instance
      end
    end
  end
end
