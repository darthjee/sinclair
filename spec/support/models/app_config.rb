# frozen_string_literal: true

class AppConfig
  extend Sinclair::ConfigClass

  add_configs :secret, app_name: 'MyApp'
end
