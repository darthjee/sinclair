# frozen_string_literal: true

class HttpJsonModel
  attr_reader :json

  class << self
    def parse(attribute, path: [])
      builder = Sinclair.new(self)

      keys = (path + [attribute]).map(&:to_s)

      builder.add_method(attribute) do
        keys.inject(hash) { |h, key| h[key] }
      end

      builder.build
    end
  end

  def initialize(json)
    @json = json
  end

  def hash
    @hash ||= JSON.parse(json)
  end
end
