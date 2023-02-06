# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Define an instance method from string
    class CallDefinition < MethodDefinition
      attr_reader :attributes

      def initialize(name, *attributes, **options)
        @attributes = attributes
        super(name, **options)
      end

      default_value :block?, false
      default_value :string?, false

      def code_string
        "#{name} :#{attributes.join(', :')}"
      end

      def class_code_string
        <<-CODE
          class << self
            #{code_string}
          end
        CODE
      end
    end
  end
end
