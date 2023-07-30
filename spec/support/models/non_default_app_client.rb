# frozen_string_literal: true

class NonDefaultAppClient
  extend Sinclair::EnvSettable

  with_settings :username, :password, :host
  setting_with_options :port, type: :integer
end
