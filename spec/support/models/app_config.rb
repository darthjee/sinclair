# frozen_string_literal: true

class AppConfig
  extend Sinclair::Config::ClassMethods

  add_configs :secret, app_name: 'MyApp'
end
