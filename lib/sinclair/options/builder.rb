# frozen_string_literal: true

class Sinclair
  class Options
    class Builder < Sinclair
      def initialize(klass, *options)
        super(klass)

        options.each do |option|
          add_method(option, cached: true) { nil }
          klass.options.push(option)
        end
      end
    end
  end
end
