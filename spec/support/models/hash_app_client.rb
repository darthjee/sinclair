# frozen_string_literal: true

require './spec/support/models/hash_settable'

class HashAppClient
  extend HashSettable

  # rubocop:disable Style/MutableConstant
  HASH = {}
  # rubocop:enable Style/MutableConstant

  with_settings :username, :password, host: 'my-host.com'
  setting_with_options :port, type: :integer
end
