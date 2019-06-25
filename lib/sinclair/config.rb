# frozen_string_literal: true

class Sinclair
  # Base class for configuration when using {Configurable}
  #
  # The methods will be added later by {ConfigFactory}
  #
  # The instance variables will be set by {ConfigBuilder}
  class Config
    autoload :ClassMethods, 'sinclair/config/class_methods'
    extend ClassMethods

    def as_json
      self.class.attributes.inject({}) do |hash, attribute|
        hash[attribute.to_s] = nil
        hash
      end
    end
  end
end
