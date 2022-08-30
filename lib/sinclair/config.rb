# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Base class for configuration when using {Configurable}
  #
  # The methods will be added later by {ConfigFactory}
  #
  # The instance variables will be set by {ConfigBuilder}
  class Config
    autoload :MethodsBuilder, 'sinclair/config/methods_builder'
    extend ConfigClass

    # Return all the current configurations in a hash
    #
    # @return [Hash]
    #
    # @example Checking all hash/json formats
    #   class LoginConfig < Sinclair::Config
    #     add_configs :password, username: 'bob'
    #   end
    #
    #   config = LoginConfig.new
    #
    #   config.to_hash
    #   # returns { 'password' => nil, 'username' => 'bob' }
    #
    #   config.as_json
    #   # returns { 'password' => nil, 'username' => 'bob' }
    #
    #   config.to_json
    #   # returns '{"password":null,"username":"bob"}'
    def to_hash
      self.class.config_attributes.each_with_object({}) do |attribute, hash|
        hash[attribute.to_s] = public_send(attribute)
      end
    end

    def default_options
      options
    end

    def options(_options_hash = {})
      self.class.options_class.new(to_hash)
    end
  end
end
