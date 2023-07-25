# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Module to be extended or included, allowing settings to be read from a source
  #
  # @see Sinclair::EnvSettable
  module Settable
    autoload :Builder,      'sinclair/settable/builder'
    autoload :Caster,       'sinclair/settable/caster'
    autoload :ClassMethods, 'sinclair/settable/class_methods'

    extend Sinclair::Settable::ClassMethods

    def read_with(&block)
      settable_module.read_with(&block)
    end

    private

    def settable_module
      singleton_class.included_modules.find do |modu|
        modu <= Sinclair::Settable
      end
    end

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
    # @return (see Sinclair#build)
    #
    # @example (see Settable)
    def with_settings(*settings_name, **defaults)
      setting_with_options(*settings_name)

      defaults.each do |key, default|
        setting_with_options(key, default: default)
      end
    end

    def setting_with_options(*settings_name, **options)
      opts = default_options.merge(options)

      Builder.build(self, settable_module, *settings_name, **opts)
    end

    def default_options
      {}
    end
  end
end
