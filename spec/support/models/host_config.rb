# frozen_string_literal: true

class HostConfig
  extend EnvSettings

  env_prefix :server

  from_env :host, :port
end
