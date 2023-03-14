# frozen_string_literal: true

class Sinclair
  # @api public
  # @author Darthjee
  class Model
    autoload :Builder, 'sinclair/model/builder'

    class << self
      def for(*attributes, **options)
        Class.new(self) do |klass|
          Builder.new(klass, *attributes, **options).build
        end
      end
    end
  end
end
