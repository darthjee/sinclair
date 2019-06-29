# frozen_string_literal: true

class MyConfig
  extend Sinclair::Config::ConfigClass

  attr_reader :name, :config
end
