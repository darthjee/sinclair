# frozen_string_literal: true

class Sinclair
  # Base class for configuration when using {Configurable}
  #
  # The methods will be added later by {ConfigFactory}
  #
  # The instance variables will be set by {ConfigBuilder}
  class Config
    autoload :ClassMethods,   'sinclair/config/class_methods'
    autoload :MethodsBuilder, 'sinclair/config/methods_builder'
    extend ClassMethods

    def to_hash
      self.class.attributes.each_with_object({}) do |attribute, hash|
        hash[attribute.to_s] = public_send(attribute)
      end
    end
  end
end
