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
    # @param config_class [Class] configuration class to be used
    # @param config_attributes [Array<Symbol,String>] list of possible configurations
    def initialize(config_class: Class.new(Config), config_attributes: [])
      @config_class = config_class
      @config_attributes = config_attributes.dup
    end

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
    #
    # @example (see ConfigFactory)
    def config
      @config ||= config_class.new
    end

    # Cleans the current config instance
    #
    # After cleaning it, {#config} will generate a new
    # instance
    #
    # @return [NilClass]
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

    # Adds possible configurations
    #
    # It change the configuration class adding methods
    #   and keeps track of those configurations so that
    #   {ConfigBuilder} is able to set those values when invoked
    #
    # @return [Array<Symbol>] all known config attributes
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
    def add_configs(*attributes)
      config_class.attr_reader(*attributes)
      config_attributes.concat(attributes.map(&:to_sym))
    end

    # Set the values in the config
    #
    # The block given is evaluated by the {ConfigBuilder}
    # where each method missed will be used to set a variable
    # in the config
    #
    # @yield [ConfigBuilder] methods called in the block
    #   that are not present in {ConfigBuilder} are
    #   then set as instance variables of the config
    #
    # @return [Object] the result of the block
    #
    # @example Setting name on config
    #   class MyConfig
    #     attr_reader :name
    #   end
    #
    #   factory = Sinclair::ConfigFactory.new(
    #     config_class: MyConfig,
    #     config_attributes: [:name]
    #   )
    #
    #   config = factory.config
    #
    #   factory.configure { name 'John' }
    #
    #   config.name # returns 'John'
    def configure(&block)
      config_builder.instance_eval(&block)
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

    # @private
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
