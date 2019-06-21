# frozen_string_literal: true

class Sinclair
  # @api public
  #
  # Module capable of giving configuration capability
  #
  # By extending Configurable, class receives the methods public
  # {ConfigFactory#config .config}, {ConfigFactory#reset_config .reset_config}
  # and {ConfigFactory#configure .configure}
  # and the private methods {#configurable_with .configurable_with}
  # and {#configurable_by .configurable_by}
  #
  # @see ConfigFactory
  # @see ConfigBuilder
  #
  # @example (see #configurable_with)
  # @example (see #configurable_by)
  module Configurable
    # (see ConfigFactory#config)
    # @see ConfigFactory#config
    def config
      config_factory.config
    end

    # (see ConfigFactory#reset_config)
    # @see ConfigFactory#reset_config
    def reset_config
      config_factory.reset_config
    end

    # (see ConfigFactory#configure)
    # @see ConfigFactory#configure
    def configure(&block)
      config_factory.configure(&block)
    end

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
      @config_factory ||= if superclass.is_a?(Configurable)
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
    #   class MyConfigurable
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
    #   class MyServerConfig
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
    #     configurable_by MyServerConfig, with: %i[host port]
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
      @config_factory = ConfigFactory.new(
        config_class: config_class,
        config_attributes: with.map(&:to_sym)
      )
    end
  end
end
