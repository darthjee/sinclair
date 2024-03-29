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

    # Returns options with configurated values
    #
    # The returned options will use the values defined in
    # the config merged with the extra attributes
    #
    # @param options_hash [Hash] optional values for the options
    #
    # @return [Sinclair::Option]
    #
    # @example returning default options
    #   class LoginConfig < Sinclair::Config
    #     add_configs :password, username: 'bob'
    #   end
    #
    #   class LoginConfigurable
    #     extend Sinclair::Configurable
    #
    #     configurable_by LoginConfig
    #   end
    #
    #   LoginConfigurable.configure do |conf|
    #     conf.username :some_username
    #     conf.password :some_password
    #   end
    #
    #   options = LoginConfigurable.config.as_options
    #
    #   config.as_options.username # returns :some_username
    #   config.as_options.password # returns :some_password
    #
    # @example returning custom options
    #   LoginConfigurable.configure do |conf|
    #     conf.username :some_username
    #     conf.password :some_password
    #   end
    #
    #   options = LoginConfigurable.config.as_options(
    #     password: :correct_password
    #   )
    #
    #   config.as_options.username # returns :some_username
    #   config.as_options.password # returns :correct_password
    def as_options(options_hash = {})
      self.class.options_class.new(to_hash.merge(options_hash))
    end
  end
end
