class Sinclair
  module Configurable
    def config
      @config ||= Sinclair::Config.new
    end

    def reset
      @config = nil
    end
  end
end
