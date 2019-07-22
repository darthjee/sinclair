# frozen_string_literal: true

class Sinclair
  # @api private
  #
  # Class responsible for configuring the configuration class
  #
  # @example General usage
  #   factory = Sinclair::ConfigFactory.new
  #   factory.add_configs(:name)
  #   factory.configure { |c| c.name 'John' }
  #
  #   config = factory.config
  #
  #   config.class.superclass       # returns Sinclair::Config
  #   factory.config.equal?(config) # returns true
  #   config.name                   # returns 'John'
  class ConfigFactory
    # @api private
    # Deprecation warning message
    # @see https://github.com/darthjee/sinclair/blob/master/WARNINGS.md#usage-of-custom-config-classes
    CONFIG_CLASS_WARNING = 'Config class is expected to be ConfigClass. ' \
      "In future releases this will be enforced.\n" \
      'see more on https://github.com/darthjee/sinclair/blob/master/WARNINGS.md#usage-of-custom-config-classes'

    # @param config_class [Class] configuration class to be used
    # @param config_attributes [Array<Symbol,String>] list of possible configurations
    def initialize(config_class: Class.new(Config), config_attributes: [])
      @config_class = config_class
      @config_attributes = config_attributes.dup

      return if config_class.is_a?(ConfigClass)

      warn CONFIG_CLASS_WARNING
    end

    # Adds possible configurations
    #
    # It change the configuration class adding methods
    #   and keeps track of those configurations so that
    #   {ConfigBuilder} is able to set those values when invoked
    #
    # @return [Array<Symbol>] all known config attributes
    # @todo remove class check once only
    #   ConfigClass are accepted
    #
    # @example Adding configuration name
    #   factory = Sinclair::ConfigFactory.new
    #   config = factory.config
    #
    #   config.respond_to? :active
    #   # returns false
    #
    #   factory.add_configs(:active)
    #
    #   config.respond_to? :active
    #   # returns true
    def add_configs(*args)
      builder = if config_class.is_a?(Sinclair::ConfigClass)
                  config_class.add_configs(*args)
                else
                  Config::MethodsBuilder.build(config_class, *args)
                end

      config_attributes.concat(builder.config_names.map(&:to_sym))
    end

    # (see Configurable#config)
    #
    # @see #reset_config
    #
    # @example (see ConfigFactory)
    def config
      @config ||= config_class.new
    end

    # (see Configurable#reset_config)
    #
    # @example
    #   factory = Sinclair::ConfigFactory.new
    #
    #   config = factory.config
    #
    #   factory.reset_config
    #
    #   factory.config == config # returns false
    def reset_config
      @config = nil
    end

    # (see Configurable#configure)
    #
    # @example Setting name on config
    #   class MyConfig
    #     extend Sinclair::ConfigClass
    #
    #     attr_reader :name, :email
    #   end
    #
    #   factory = Sinclair::ConfigFactory.new(
    #     config_class: MyConfig,
    #     config_attributes: %i[name email]
    #   )
    #
    #   config = factory.config
    #
    #   factory.configure(email: 'john@server.com') do
    #     name 'John'
    #   end
    #
    #   config.name  # returns 'John'
    #   config.email # returns 'john@server.com'
    def configure(config_hash = {}, &block)
      config_builder.instance_eval(&block) if block

      config_builder.instance_eval do
        config_hash.each do |key, value|
          public_send(key, value)
        end
      end
    end

    # Returns a new instance of ConfigFactory
    #
    # the new instance will have the same
    # config_attributes and for config_class a child
    # of the current config_class
    #
    # This method is called when initializing {Configurable}
    # config_factory and the superclass is also configurable
    #
    # This way, child classes from other {Configurable} classes
    # will have a config_class that is a child from the original
    # config_class
    #
    # @return [ConfigFactory]
    def child
      self.class.new(
        config_class: Class.new(config_class),
        config_attributes: config_attributes
      )
    end

    private

    # method config_class
    # @private
    #
    # Configuration class to be used
    #
    # @return [Class]

    # @method config_attributes
    # @private
    #
    # List of possible configurations
    #
    # @return [Array<Symbol,String>]
    attr_reader :config_class, :config_attributes

    # @private
    #
    # Returns a builder capable of injecting variables into config
    #
    # @return [ConfigBuilder]
    def config_builder
      ConfigBuilder.new(config, *config_attributes)
    end
  end
end
