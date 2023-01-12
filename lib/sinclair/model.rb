# frozen_string_literal: true

class Sinclair
  # @api public
  # @author Darthjee
  class Model
    autoload :Builder, 'sinclair/model/builder'

    class << self
      def with_attributes(*attributes, **options)
        Builder.new(self, *attributes, **options).build
      end
    end

    def initialize
    end
  end
end
