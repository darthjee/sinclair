# frozen_string_literal: true

class Sinclair
  class ConfigFactory
    def initialize(config_class: Class.new(Config))
      @config_class = config_class
    end

    def config
      @config ||= config_class.new
    end

    def reset
      @config = nil
    end

    def add_configs(*attributes)
      config_class.attr_accessor(*attributes)
    end

    def configure(&block)
      config_builder.instance_eval(&block)
    end

    def child
      self.class.new(config_class: Class.new(config_class))
    end

    private

    attr_reader :config_class

    def config_builder
      ConfigBuilder.new(config)
    end
  end
end
