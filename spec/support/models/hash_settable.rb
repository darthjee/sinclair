# frozen_string_literal: true

module HashSettable
  extend Sinclair::Settable::ClassMethods
  include Sinclair::Settable

  read_with do |key, default: nil|
    self::HASH[key] || default
  end
end
