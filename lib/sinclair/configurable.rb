class Sinclair
  module Configurable
    delegate :config, :reset, to: :config_factory

    private

    def configurable_with(*attributes)
    end

    def config_factory
      @config_factory ||= ConfigFactory.new
    end
  end
end
