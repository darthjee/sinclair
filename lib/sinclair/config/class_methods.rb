# frozen_string_literal: true

class Sinclair
  class Config
    # @api public
    #
    # Module with all class methods for {Config}
    #
    # Any class that will be used as configuration class
    # should extend {ClassMethods} as {#attributes}
    # is used to check what configurations have been added
    #
    # @example (see #add_configs)
    module ClassMethods
      # @api private
      #
      # Adds an attribute to the list of attributes
      #
      # The list of attributes represent attribute
      # readers that class instances can respond to
      #
      # This method does not add the method or .attr_reader
      #
      # @param attributes [Array<Symbol,String>] list of
      #   attributes the instances should respond to
      #
      # @return [Array<Symbol>] all attributes the class have
      #
      # @see #attributes
      def add_attributes(*attributes)
        new_attributes = attributes.map(&:to_sym) - self.attributes
        config_attributes.concat(new_attributes)
      end

      # @api private
      #
      # List of all attributes the instances responds to
      #
      # Subclasses will respond to the same attributes as the
      # parent class plus it's own
      #
      # @return [Array<Symbol>]
      def attributes
        if superclass.is_a?(Config::ClassMethods)
          (superclass.attributes + config_attributes).uniq
        else
          config_attributes
        end
      end

      # Add a config attribute
      #
      # This method adds an attribute (see {#add_attributes})
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
      #     extend Sinclair::Config::ClassMethods
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

          add_attributes(*builder.config_names)
        end
      end

      private

      # @api private
      #
      # @private
      #
      # List of attributes defined for this class only
      #
      # @return [Array<Symbol>]
      def config_attributes
        @config_attributes ||= []
      end
    end
  end
end
