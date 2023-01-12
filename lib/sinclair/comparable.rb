# frozen_string_literal: true

require 'sinclair/comparable/class_methods'

class Sinclair
  # @api public
  # @author darthjee
  module Comparable
    extend ActiveSupport::Concern

    def ==(other)
      self.class.equals_checker.match?(self, other)
    end
  end
end
