# frozen_string_literal: true

class Sinclair
  module Comparable
    module ClassMethods
      def comparable_by(*attributes)
        equals_checker.add(*attributes)
      end

      def equals_checker
        @equals_checker ||= Sinclair::EqualsChecker.new
      end
    end
  end
end
