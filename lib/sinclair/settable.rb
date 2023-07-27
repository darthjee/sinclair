# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Module to be extended or included, allowing settings to be read from a source
  #
  # @see Sinclair::EnvSettable
  #
  # @example Creating a custom settable
  #
  #   module HashSettable
  #     extend Sinclair::Settable::ClassMethods
  #     include Sinclair::Settable
  #
  #     read_with do |key, default: nil|
  #       self::HASH[key] || default
  #     end
  #   end
  #
  #   class HashAppClient
  #     extend HashSettable
  #
  #     HASH = {}
  #
  #     with_settings :username, :password, host: 'my-host.com'
  #     setting_with_options :port, type: :integer
  #   end
  #
  #   ENV[:username] = 'my_login'
  #   ENV[:port]     = '8080'
  #
  #   HashAppClient.username # returns 'my_login'
  #   HashAppClient.password # returns nil
  #   HashAppClient.host     # returns 'my-host.com'
  #   HashAppClient.port     # returns 8080
  module Settable
    autoload :Builder,      'sinclair/settable/builder'
    autoload :Caster,       'sinclair/settable/caster'
    autoload :ClassMethods, 'sinclair/settable/class_methods'

    extend Sinclair::Settable::ClassMethods

    # @api private
    #
    # returns the settable module that the class extends
    #
    # This is used in order to find out what is the read block used
    # by the settable
    #
    # @return [Module] a +Sinclair::Settable+
    def settable_module
      @settable_module ||= singleton_class.included_modules.find do |modu|
        modu <= Sinclair::Settable
      end
    end

    private

    # @private
    # @api public
    # @visibility public
    #
    # Adds settings
    #
    # @param settings_name [Array<Symbol,String>] Name of all settings
    #   to be added
    # @param defaults [Hash] Settings with default values
    #
    # @example (see Settable)
    # @example (see EnvSettable)
    #
    # @see setting_with_options
    #
    # @return [Hash<Symbol, Object>]
    def with_settings(*settings_name, **defaults)
      setting_with_options(*settings_name)

      defaults.each do |key, default|
        setting_with_options(key, default: default)
      end
    end

    # @private
    # @api public
    # @visibility public
    #
    # Add setting with options
    #
    # @param settings_name [Array<Symbol,String>] Name of all settings
    #   to be added
    # @param options [Hash<Symbol, Object>] setting exposition options
    # @option options type [Symbol] type to cast the value fetched
    #
    # @see with_settings
    # @return (see Sinclair#build)
    def setting_with_options(*settings_name, **options)
      opts = default_options.merge(options)

      Builder.build(self, *settings_name, **opts)
    end

    # @private
    # @api private
    #
    # Default options when creating the method
    #
    # @return [Hash]
    def default_options
      {}
    end
  end
end
