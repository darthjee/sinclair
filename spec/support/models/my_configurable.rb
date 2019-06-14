# frozen_string_literal: true

class MyConfigurable
  extend Sinclair::Configurable

  configurable_with :host, :port
end
