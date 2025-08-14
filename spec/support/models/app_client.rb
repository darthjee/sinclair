# frozen_string_literal: true

class AppClient
  extend Sinclair::EnvSettable

  with_settings :username, :password, host: 'my-host.com'
  setting_with_options :port, type: :integer
  setting_with_options :domain, cached: true
end
