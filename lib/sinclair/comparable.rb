# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  module Comparable
    def comparable_by(*attributes)
      @equals_checker = Sinclair::EqualsChecker.new(*attributes)
    end

    def equals_checker
      @equals_checker ||= Sinclair::EqualsChecker.new
    end
  end
end
