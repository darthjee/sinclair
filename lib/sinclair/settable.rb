# frozen_string_literal: true

class Sinclair
  module Settable
    autoload :Builder,      'sinclair/settable/builder'
    autoload :ClassMethods, 'sinclair/settable/class_methods'

    def read_with
      settable_module.read_with
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
      Builder.build(self, read_with, *settings_name, **defaults)
    end
  end
end
