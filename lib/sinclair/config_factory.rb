# frozen_string_literal: true

class Sinclair
  class ConfigFactory
    def initialize(config_class: Class.new(Config), config_attributes: [])
      @config_class = config_class
      @config_attributes = config_attributes
    end

    def config
      @config ||= config_class.new
    end

    def reset
      @config = nil
    end

    def add_configs(*attributes)
      config_class.attr_accessor(*attributes)
      config_attributes.concat(attributes)
    end

    def configure(&block)
      config_builder.instance_eval(&block)
    end

    def child
      self.class.new(
        config_class: Class.new(config_class),
        config_attributes: config_attributes.dup
      )
    end

    private

    attr_reader :config_class, :config_attributes

    def config_builder
      ConfigBuilder.new(config, config_attributes)
    end
  end
end
