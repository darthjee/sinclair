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

    private

    def config_class
      @config_class ||= Class.new(Config)
    end
  end
end

