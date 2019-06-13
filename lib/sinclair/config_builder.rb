# frozen_string_literal: true

class Sinclair
  class ConfigBuilder
    def initialize(config, config_attributes)
      @config = config
      @config_attributes = config_attributes
    end

    private

    def method_missing(method_name, *args)
      return super unless @config_attributes.include?(method_name)

      @config.instance_variable_set("@#{method_name}", *args)
    end
  end
end
