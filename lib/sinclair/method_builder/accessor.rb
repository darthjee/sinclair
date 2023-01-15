# frozen_string_literal: true

class Sinclair
  class MethodBuilder
    # @api private
    # @author darthjee
    class Accessor < Base
      def initialize(klass, *attributes, type:)
        @klass      = klass
        @attributes = attributes.flatten
        @type       = type
      end

      def build
        if instance?
          klass.attr_accessor(*attributes)
        else
          klass.module_eval(code_string)
        end
      end

      private

      attr_reader :attributes

      def code_string
        <<-CODE
          class << self
            attr_accessor :#{attributes.join(', :')}
          end
        CODE
      end
    end
  end
end
