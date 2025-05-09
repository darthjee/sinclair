# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Module capable of giving configuration capability
  #
  # By extending Configurable, class receives the methods public
  # {ConfigFactory#config .config}, {ConfigFactory#reset_config .reset_config}
  # and {ConfigFactory#configure .configure}
  # and the private methods {#configurable_with .configurable_with},
  # {#configurable_by .configurable_by} and {#as_options .as_options}
  #
  # @see ConfigFactory
  # @see ConfigBuilder
  #
  # @example (see #configurable_with)
  # @example (see #configurable_by)
  module Configurable
    # @api private
    # Deprecation warning message
    # @see https://github.com/darthjee/sinclair/blob/master/WARNINGS.md#usage-of-custom-config-classes
    CONFIG_CLASS_WARNING = 'Config classes attributes should ' \
      'be defined inside the class or through the usage of ' \
      "configurable_with.\n" \
      "In future releases this will be enforced.\n" \
      'see more on https://github.com/darthjee/sinclair/blob/master/WARNINGS.md#usage-of-custom-config-classes'

    # @method config
    #
    # @api public
    #
    # Returns current instance of config
    #
    # the method returns the same instance until +reset_config+
    # is called
    #
    # @return [Config,Object] the instance of given
    #   config_class. by default, this returns
    #   +Class.new(Config).new+
    #
    # @see #reset_config
    # @see ConfigFactory#config

    # @method reset_config
    #
    # @api public
    #
    # Cleans the current config instance
    #
    # After cleaning it, {#config} will generate a new
    # instance
    #
    # @return [NilClass]
    #
    # @see ConfigFactory#reset_config

    # @method configure(config_hash = {}, &block)
    #
    # @api public
    #
    # Set the values in the config
    #
    # The block given is evaluated by the {ConfigBuilder}
    # where each method missed will be used to set a variable
    # in the config
    #
    # @param config_hash [Hash] hash with keys and values for
    #   the configuration
    #
    # @yield [ConfigBuilder] methods called in the block
    #   that are not present in {ConfigBuilder} are
    #   then set as instance variables of the config
    #
    # @return [Object] the result of the block
    #
    # @see ConfigFactory#configure
    delegate :config, :reset_config, :configure, to: :config_factory

    # @method as_options(options_hash = {})
    # @api public
    #
    # Returns options with configurated values
    #
    # @param (see Sinclair::Config#as_options)
    # @return (see Sinclair::Config#as_options)
    # @example (see Sinclair::Config#as_options)
    delegate :as_options, to: :config

    protected

    # @api private
    #
    # @private
    #
    # Generates a config factory
    #
    # When the current class is a child of a class extending
    # {Configurable}, config_factory will be initialized with
    # parameters to generate a configuration child from the
    # original factory config
    #
    # @see ConfigFactory#child
    #
    # @return [ConfigFactory]
    def config_factory
      @config_factory ||= if is_a?(Class) && superclass.is_a?(Configurable)
                            superclass.config_factory.child
                          else
                            ConfigFactory.new
                          end
    end

    private

    # @!visibility public
    #
    # Adds a configuration option to config class
    #
    # @return [Array<Symbol>] list of possible
    #   configurations
    #
    # @see ConfigFactory#add_configs
    #
    # @example Configuring with common {Sinclair::Config} class
    #   module MyConfigurable
    #     extend Sinclair::Configurable
    #
    #     # port is defaulted to 80
    #     configurable_with :host, port: 80
    #   end
    #
    #   MyConfigurable.configure do
    #     host 'interstella.com'
    #     port 5555
    #   end
    #
    #   MyConfigurable.config.host
    #   # returns 'interstella.com'
    #
    #   MyConfigurable.config.port
    #   # returns 5555
    #
    #   MyConfigurable.reset_config
    #
    #   MyConfigurable.config.host
    #   # returns nil
    #
    #   MyConfigurable.config.port
    #   # returns 80
    def configurable_with(*attributes)
      config_factory.add_configs(*attributes)
    end

    # @!visibility public
    #
    # Allows configuration to happen through custom config class
    #
    # @param config_class [Class] custom configuration class
    # @param with [Array<Symbol,String>] List of all
    #   configuration attributes expected to be found on
    #   +config_class+
    #
    # configurable_with does not add methods to config_class.
    # If needed, those can be added by a subsequent call to
    # {#configurable_with}
    #
    # @return [ConfigFactory]
    #
    # @example Configured by custom config class
    #   class MyServerConfig < Sinclair::Config
    #     config_attributes :host, :port
    #
    #     def url
    #       if @port
    #         "http://#{@host}:#{@port}"
    #       else
    #         "http://#{@host}"
    #       end
    #     end
    #   end
    #
    #   class Client
    #     extend Sinclair::Configurable
    #
    #     configurable_by MyServerConfig
    #   end
    #
    #   Client.configure do
    #     host 'interstella.com'
    #   end
    #
    #   Client.config.url # returns 'http://interstella.com'
    #
    #   Client.configure do |config|
    #     config.port 8080
    #   end
    #
    #   Client.config.url # returns 'http://interstella.com:8080'
    def configurable_by(config_class, with: [])
      warn CONFIG_CLASS_WARNING if with.present?

      @config_factory = ConfigFactory.new(
        config_class:,
        config_attributes: with.map(&:to_sym)
      )
    end
  end
end
