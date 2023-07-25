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
  end
end
