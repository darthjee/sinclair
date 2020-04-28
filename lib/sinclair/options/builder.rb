# frozen_string_literal: true

class Sinclair
  class Options
    class Builder < Sinclair
      include Sinclair::InputHashable

      def initialize(klass, *options, **defaults)
        super(klass)

        @attributes = input_hash(*options, **defaults)

        add_all_methods
      end

      private

      attr_reader :attributes

      def add_all_methods
        attributes.each do |option, value|
          add_method(option, cached: true) { value }
          klass.options.push(option)
        end
      end
    end
  end
end
