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
      instance_eval(&block)
    end

    def child
      self.class.new(config_class: Class.new(config_class))
    end

    private

    attr_reader :config_class

    def method_missing(method_name, *args)
      config.public_send("#{method_name}=", *args)
    end
  end
end
