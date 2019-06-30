# frozen_string_literal: true

require './spec/support/models/my_server_config'

class Client
  extend Sinclair::Configurable

  configurable_by MyServerConfig
end
