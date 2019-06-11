class Sinclair
  class ConfigFactory
    def config
      @config ||= config_class.new
    end

    def reset
      @config = nil
    end

    def add_configs(*attributes)
      config_class.attr_accessor *attributes
    end

    def configure(&block)
      instance_eval(&block)
    end

    def method_missing(method_name, *args)
      config.public_send("#{method_name}=", *args)
    end

    private

    def config_class
      @config_class ||= Class.new(Config)
    end
  end
end

