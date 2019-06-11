class Sinclair
  module Configurable
    def config
      @config ||= Sinclair::Config.new
    end

    def reset
      @config = nil
    end

    private

    def configurable_with(*attributes)
    end

    def config_factory
      @config_factory ||= ConfigFactory.new
    end
  end
end
