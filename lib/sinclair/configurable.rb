# frozen_string_literal: true

class Sinclair
  module Configurable
    delegate :config, :reset_config, :configure, to: :config_factory

    protected

    def config_factory
      @config_factory ||= if superclass.is_a?(Configurable)
                            superclass.config_factory.child
                          else
                            ConfigFactory.new
                          end
    end

    private

    def configurable_with(*attributes)
      config_factory.add_configs(*attributes)
    end
  end
end
