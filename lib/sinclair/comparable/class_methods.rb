# frozen_string_literal: true

class Sinclair
  module Comparable
    # @api public
    # @author darthjee
    #
    # Class methods of {Sinclair::Comparable}
    #
    # @example (see Sinclair::Comparable)
    module ClassMethods
      # Adds fields to the comparison algorythim
      #
      # @param attributes [Array<Symbol>] attributes to be added to comparison
      #
      # @see Sinclair::EqualsChecker
      # @example (see Sinclair::Comparable)
      def comparable_by(*attributes)
        equals_checker.add(*attributes)
      end

      # @api private
      # 
      # Returns a comparable configured for the class
      #
      # @return [Sinclair::EqualsChecker]
      def equals_checker
        @equals_checker ||= Sinclair::EqualsChecker.new
      end
    end
  end
end
