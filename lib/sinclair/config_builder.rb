# frozen_string_literal: true

class Sinclair
  class ConfigBuilder
    def initialize(config)
      @config = config
    end

    private

    attr_reader :config

    def method_missing(method_name, *args)
      config.public_send("#{method_name}=", *args)
    end
  end
end
