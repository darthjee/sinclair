# frozen_string_literal: true

class Sinclair
  class Model
    # @api public
    # @author Darthjee
    class Builder < Sinclair
      def initialize(klass, *attributes, writter: true)
        super(klass)
        @attributes = attributes.flatten
        @options    = options
        @writter    = writter

        add_methods
        change_initializer
      end

      private

      attr_reader :attributes, :options, :writter
      alias writter? writter

      def add_methods
        call = writter? ? :attr_accessor : :attr_reader

        add_method(call, *attributes, type: :call)
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
