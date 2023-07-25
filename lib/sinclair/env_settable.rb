# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Module to be extended allowing configurations from environment
  #
  # @example
  #   class MyAppClient
  #     extend Sinclair::EnvSettable
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
  module EnvSettable
    include Sinclair::Settable
    extend Sinclair::Settable::ClassMethods

    read_with do |key, settable, default|
      env_key = [settable.settings_prefix, key].compact.join('_').to_s.upcase

      ENV[env_key] || default
    end

    # Sets environment keys prefix
    #
    # @param prefix [String] prefix of the env keys
    #
    # @return [String]
    #
    # @example (see Settable)
    def settings_prefix(prefix = @settings_prefix)
      @settings_prefix = prefix || superclass_prefix
    end

    private

    def superclass_prefix
      return unless superclass.is_a?(Sinclair::EnvSettable)

      superclass.settings_prefix
    end
  end
end
