# frozen_string_literal: true

class HashAppClient
  extend Sinclair::Settable

  HASH = {}

  read_with do |key, default: nil|
    HASH[key] || default
  end

  with_settings :username, :password, host: 'my-host.com'
end
