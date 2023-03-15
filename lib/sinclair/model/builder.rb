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

        add_method(call, *attributes_names, type: :call)
      end

      def change_initializer
        code = attributes_names.map do |attr|
          "@#{attr} = #{attr}"
        end.join("\n")

        add_method(:initialize, code, named_parameters: attributes)
      end

      def attributes_names
        @attributes_names ||= attributes.map do |attr|
          attr.try(:keys) || attr.to_s
        end.flatten
      end
    end
  end
end
