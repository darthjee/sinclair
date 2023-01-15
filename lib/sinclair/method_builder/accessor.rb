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
          klass.module_eval(code_string)
        else
          klass.module_eval(class_code_string)
        end
      end

      private

      attr_reader :attributes

      def code_string
        "attr_#{accessor_type} :#{attributes.join(', :')}"
      end

      def class_code_string
        <<-CODE
          class << self
            #{code_string}
          end
        CODE
      end

      def accessor_type
        :accessor
      end
    end
  end
end
