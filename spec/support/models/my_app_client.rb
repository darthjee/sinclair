# frozen_string_literal: true

class MyAppClient
  extend Sinclair::Settable

  settings_prefix 'MY_APP'

  with_settings :username, :password, host: 'my-host.com'
end
