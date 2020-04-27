# frozen_string_literal: true

class Sinclair
  class Options
    class << self
      private

      def with_options(*options)
        builder = Sinclair.new(self)

        options.each do |option|
          builder.add_method(option, cached: true) { nil }
        end

        builder.build
      end
    end

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
