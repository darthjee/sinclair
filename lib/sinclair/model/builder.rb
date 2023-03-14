# frozen_string_literal: true

class Sinclair
  class Model
    # @api public
    # @author Darthjee
    class Builder < Sinclair
      attr_reader :attributes, :options

      def initialize(klass, *attributes, **options)
        super(klass)
        @attributes = attributes.flatten
        @options = options

        add_methods
        change_initializer
      end

      private

      def add_methods
        add_method(:attr_accessor, *attributes, type: :call)
      end

      def change_initializer
        code = attributes.map do |attr|
          "@#{attr} = #{attr}"
        end.join("\n")

        add_method(:initialize, code, named_parameters: attributes)
      end
    end
  end
end
