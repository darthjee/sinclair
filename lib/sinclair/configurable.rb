# frozen_string_literal: true

class Sinclair
  # @api public
  #
  # Module capable of giving configuration capability
  #
  # By extending Configurable, class receives the methods public
  # {ConfigFactory#config .config}, {ConfigFactory#reset_config .reset_config}
  # and {ConfigFactory#configure .configure}
  # and the private {#configurable_with .configurable_with}
  #
  # @see ConfigFactory
  # @see ConfigBuilder
  #
  # @example
  #   class MyConfigurable
  #     extend Sinclair::Configurable
  #
  #     configurable_with :host, :port
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
  #   MyConfigurable.reset
  #
  #   MyConfigurable.config.host
  #   # returns nil
  module Configurable
    delegate :config, :reset_config, :configure, to: :config_factory

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
    # @example (see Configurable)
    def configurable_with(*attributes)
      config_factory.add_configs(*attributes)
    end
  end
end
