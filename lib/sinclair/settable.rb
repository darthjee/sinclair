# frozen_string_literal: true

class Sinclair
  module Settable
    autoload :Builder,      'sinclair/settable/builder'
    autoload :ClassMethods, 'sinclair/settable/class_methods'

    def read_with
      self.singleton_class.included_modules.find { |m| m <= Sinclair::Settable }.read_with
    end

    private

    # @private
    # @api public
    # @visibility public
    #
    # Sets environment keys prefix
    #
    # @param prefix [String] prefix of the env keys
    #
    # @return [String]
    #
    # @example (see Settable)
    def settings_prefix(prefix)
      @settings_prefix = prefix
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
      Builder.build(self, @settings_prefix, self.read_with, *settings_name, **defaults)
    end
  end
end
