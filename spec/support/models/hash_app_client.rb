# frozen_string_literal: true

require './spec/support/models/hash_settable'

class HashAppClient
  extend HashSettable

  # rubocop:disable-next Style/MutableConstant
  HASH = {}

  with_settings :username, :password, host: 'my-host.com'
  setting_with_options :port, type: :integer
  setting_with_options :domain, cached: true
  setting_with_options :secret, cached: false
end
