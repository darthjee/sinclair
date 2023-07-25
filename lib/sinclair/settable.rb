# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Module to be extended allowing configurations from environment
  #
  # @example
  #   class MyAppClient
  #     extend Sinclair::Settable
  #
  #     settings_prefix 'MY_APP'
  #
  #     with_settings :username, :password, host: 'my-host.com'
  #   end
  #
  #   ENV['MY_APP_USERNAME'] = 'my_login'
  #
  #   MyAppClient.username # returns 'my_login'
  #   MyAppClient.password # returns nil
  #   MyAppClient.host     # returns 'my-host.com'
  #
  #   ENV['MY_APP_HOST'] = 'other-host.com'
  #
  #   MyAppClient.host     # returns 'other-host.com'
  #
  module Settable
    autoload :Builder, 'sinclair/settable/builder'

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
      Builder.new(self, @settings_prefix, *settings_name, **defaults).build
    end
  end
end
