# frozen_string_literal: true

class Sinclair
  # @api public
  #
  # Module with all class methods for {Config}
  #
  # Any class that will be used as configuration class
  # should extend {ConfigClass} as {#config_attributes}
  # is used to check what configurations have been added
  #
  # @example (see #add_configs)
  module ConfigClass
    # @api private
    #
    # Adds an attribute to the list of attributes
    #
    # The list of attributes represent attribute
    # readers that class instances can respond to
    #
    # Subclasses will respond to the same attributes as the
    # parent class plus it's own
    #
    # This method does not add the method or .attr_reader
    #
    # @param attributes [Array<Symbol,String>] list of
    #   attributes the instances should respond to
    #
    # @return [Array<Symbol>] all attributes the class have
    #
    # @see #attributes
    def config_attributes(*attributes)
      @config_attributes ||= []

      if attributes.present?
        new_attributes = attributes.map(&:to_sym) - @config_attributes
        @config_attributes.concat(new_attributes)
      end

      if superclass.is_a?(ConfigClass)
        (superclass.config_attributes.dup + @config_attributes).uniq
      else
        @config_attributes
      end
    end

    # Add a config attribute
    #
    # This method adds an attribute (see {#config_attributes})
    # and the method readers
    #
    # @overload add_configs(*names, default)
    #   @param names [Array<Symbol,String>] List of configuration names
    #     to be added
    #   @param default [Hash] Configurations that will receive a default
    #     value when not configured
    #
    # @return [MethodsBuilder]
    #
    # @see MethodsBuilder#build
    #
    # @example Adding configurations to config class
    #   class AppConfig
    #     extend Sinclair::ConfigClass
    #
    #     add_configs :secret, app_name: 'MyApp'
    #   end
    #
    #   config = AppConfig.new
    #
    #   config.secret
    #   # return nil
    #
    #   config.app_name
    #   # return 'MyApp'
    #
    #   config_builder = Sinclair::ConfigBuilder.new(config)
    #
    #   config_builder.secret '123abc'
    #   config_builder.app_name 'MySuperApp'
    #
    #   config.secret
    #   # return '123abc'
    #
    #   config.app_name
    #   # return 'MySuperApp'
    def add_configs(*args)
      Config::MethodsBuilder.new(self, *args).tap do |builder|
        builder.build

        config_attributes(*builder.config_names)
      end
    end
  end
end
