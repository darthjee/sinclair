# frozen_string_literal: true

class DummyConfigurable
  extend Sinclair::Configurable

  configurable_with :user, 'password'
end
