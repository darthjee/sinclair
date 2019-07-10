# frozen_string_literal: true

class MyConfig
  extend Sinclair::ConfigClass

  attr_reader :name, :email, :config
end
