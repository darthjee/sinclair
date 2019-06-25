# frozen_string_literal: true

class MyConfig
  extend Sinclair::Config::ClassMethods

  attr_reader :name, :config
end
