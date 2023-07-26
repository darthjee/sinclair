# frozen_string_literal: true

module JsonEnvSettable
  include Sinclair::EnvSettable
  extend Sinclair::Settable::ClassMethods

  class Caster < Sinclair::Settable::Caster
    cast_with(:json) { |value| JSON.parse(value) }
  end

  read_with do |key, default: nil, prefix: nil|
    env_key = [prefix, key].compact.join('_').to_s.upcase

    ENV[env_key] || default
  end
end

class JsonEnvSettings
  extend JsonEnvSettable

  settings_prefix 'JSON'

  setting_with_options :config, type: :json
end
