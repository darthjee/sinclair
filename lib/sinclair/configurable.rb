class Sinclair
  module Configurable
    delegate :config, :reset, :configure, to: :config_factory

    protected

    def config_factory
      @config_factory ||= superclass.is_a?(Configurable) ? superclass.config_factory.child : ConfigFactory.new
    end

    private

    def configurable_with(*attributes)
      config_factory.add_configs(*attributes)
    end
  end
end
