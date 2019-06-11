class Sinclair
  class ConfigFactory
    def config
      @config ||= Config.new
    end

    def reset
      @config = nil
    end
  end
end

