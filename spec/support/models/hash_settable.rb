# frozen_string_literal: true

module HashSettable
  extend Sinclair::Settable::ClassMethods
  include Sinclair::Settable

  read_with do |key|
    self::HASH[key]
  end
end
