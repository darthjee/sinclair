# frozen_string_literal: true

class MyAppClient
  extend Sinclair::EnvSettable

  settings_prefix 'MY_APP'

  has_settings :username, :password, host: 'my-host.com'
end
