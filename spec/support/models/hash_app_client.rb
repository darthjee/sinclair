# frozen_string_literal: true

class HashAppClient
  extend Sinclair::Settable

  # rubocop:disable Style/MutableConstant
  HASH = {}
  # rubocop:enable Style/MutableConstant

  read_with do |key, default: nil|
    HASH[key] || default
  end

  with_settings :username, :password, host: 'my-host.com'
  setting_with_options :port, type: :integer
end
