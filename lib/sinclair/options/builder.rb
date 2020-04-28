# frozen_string_literal: true

class Sinclair
  class Options
    class Builder < Sinclair
      def initialize(klass, *options, **defaults)
        super(klass)

        attributes = Hash[options.map { |name| [name] }]
        attributes.merge!(defaults)

        attributes.each do |option, value|
          add_method(option, cached: true) { value }
          klass.options.push(option)
        end
      end
    end
  end
end
