# frozen_string_literal: true

class Sinclair
  # @api private
  # @author darthjee
  #
  # Class responsible for setting the values on configuration
  #
  # @example
  #   class MyConfig
  #     extend Sinclair::ConfigClass
  #
  #     attr_reader :name, :config
  #   end
  #
  #   config = MyConfig.new
  #
  #   builder = Sinclair::ConfigBuilder.new(config, :name)
  #
  #   builder.instance_eval { |c| c.name 'John' }
  #
  #   config.name # returns 'John'
  class ConfigBuilder
    # A new instance of ConfigBuilder
    #
    # @param config [Sinclair::Config] config object to be build
    #   config object has no attribute setters (only readers)
    #   so all attributes are set as instance variable
    #
    # @param config_attributes [Array<Symbol>] list of attributes
    #   that can be set on config (expecting that config has
    #   the right attribute readers)
    def initialize(config, *config_attributes)
      @config = config
      @config_attributes = config_attributes
    end

    private

    # @private
    #
    # Method called for methods missing
    #
    # When a method is missing, it is expected that it is the
    # name of a variable to be set on config (as long as it was
    # defined in the config_attributes_array)
    #
    # @param method_name [Symbol] name of the method called
    # @param args [Array<Object>] arguments of the call
    #
    # @return [Object]
    def method_missing(method_name, *args)
      return super unless method_included?(method_name)

      @config.instance_variable_set("@#{method_name}", *args)
    end

    # @private
    #
    # Checks if method missing will catch the method called
    #
    # @return [TrueClass,FalseClass]
    #
    # @see #method_missing
    def respond_to_missing?(method_name, include_private)
      method_included?(method_name) || super
    end

    # Checks if a method is included in the methods defined
    #
    # @param method_name [Symbol] name of the method called
    #
    # @return [TrueClass,FalseClass]
    #
    # @todo get rid of @config_attributes when only
    #   Sinclair::ConfigClass are accepted
    def method_included?(method_name)
      klass = @config.class

      @config_attributes.include?(method_name) ||
        klass.is_a?(Sinclair::ConfigClass) &&
          klass.config_attributes.include?(method_name)
    end
  end
end
