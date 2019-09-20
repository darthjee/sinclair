# frozen_string_literal: true

class AppClient
  extend Sinclair::EnvSettable

  with_settings :username, :password, host: 'my-host.com'
end
