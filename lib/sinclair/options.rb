# frozen_string_literal: true

class Sinclair
  class Options
    class << self
      private

      def with_options(*options)
        builder = Sinclair.new(self)

        options.each do |option|
          builder.add_method(option) { nil }
        end

        builder.build
      end
    end
  end
end
