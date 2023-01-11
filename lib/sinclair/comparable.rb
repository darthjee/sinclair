# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  module Comparable
    extend ActiveSupport::Concern

    included do |klass|
      def klass.comparable_by(*attributes)
        @equals_checker = Sinclair::EqualsChecker.new(*attributes)
      end

      def klass.equals_checker
        @equals_checker ||= Sinclair::EqualsChecker.new
      end
    end

    def ==(other)
      self.class.equals_checker.match?(self, other)
    end
  end
end
