# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # module to be extended allowing configurations from environment
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
    autoload :Builder, 'sinclair/env_settable/builder'

    def settings_prefix(prefix)
      @settings_prefix = prefix
    end

    def with_settings(*settings_name, **defaults)
      Builder.new(self, @settings_prefix, *settings_name, **defaults).build
    end
  end
end
