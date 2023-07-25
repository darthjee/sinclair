# frozen_string_literal: true

module HashSettable
  extend Sinclair::Settable::ClassMethods
  include Sinclair::Settable

  # rubocop:disable Style/MutableConstant
  HASH = {}
  # rubocop:enable Style/MutableConstant

  read_with do |key, default: nil|
    HASH[key] || default
  end
end
