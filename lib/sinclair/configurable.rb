class Sinclair
  module Configurable
    delegate :config, :reset, :configure, to: :config_factory

    private

    def configurable_with(*attributes)
      config_factory.add_configs(*attributes)
    end

    def config_factory
      @config_factory ||= ConfigFactory.new
    end
  end
end
