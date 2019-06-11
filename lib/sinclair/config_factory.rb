class Sinclair
  class ConfigFactory
    def config
      @config ||= config_class.new
    end

    def reset
      @config = nil
    end

    private

    def config_class
      @config_class ||= Class.new(Config)
    end
  end
end

