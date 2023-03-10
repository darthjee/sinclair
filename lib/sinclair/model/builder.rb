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
      end

      private

      def add_methods
        attributes.each do |attribute|
          add_method(:attr_accessor, attribute, type: :call)
        end
      end
    end
  end
end
