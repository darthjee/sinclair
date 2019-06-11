class Sinclair
  module Configurable
    def config
      @config ||= Sinclair::Config.new
    end

    def reset
      @config = nil
    end

    private

    def configurable_with(*attributes)
    end
  end
end
