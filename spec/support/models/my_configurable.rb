# frozen_string_literal: true

module MyConfigurable
  extend Sinclair::Configurable

  # port is defaulted to 80
  configurable_with :host, port: 80
end
