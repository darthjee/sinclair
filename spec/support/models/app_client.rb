# frozen_string_literal: true

class AppClient
  extend Sinclair::EnvSettable

  has_settings :username, :password
end
