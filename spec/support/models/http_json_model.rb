# frozen_string_literal: true

class HttpJsonModel
  attr_reader :json

  class << self
    def parse(attribute, path: [])
      keys = (path + [attribute]).map(&:to_s)

      Sinclair.build(self) do
        add_method(attribute) do
          keys.inject(hash) { |h, key| h[key] }
        end
      end
    end
  end

  def initialize(json)
    @json = json
  end

  def hash
    @hash ||= JSON.parse(json)
  end
end
