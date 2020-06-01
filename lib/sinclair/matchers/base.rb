# frozen_string_literal: true

class Sinclair
  module Matchers
    # @abstract
    # @api private
    #
    # Base class for all matchers
    class Base < RSpec::Matchers::BuiltIn::BaseMatcher
      # @param method_name [String,Symbol] the method, to be checked, name
      def initialize(method_name)
        @method_name = method_name.to_sym
      end

      # definition needed for block matchers
      #
      # @return [Boolean]
      def supports_block_expectations?
        true
      end

      # Checkes if another instnce is equal self
      #
      # @return [Boolean]
      def equal?(other)
        return unless other.class == self.class

        other.method_name == method_name &&
          other.try(:klass) == try(:klass)
      end

      alias == equal?

      protected

      # @method method_name
      # @private
      #
      # The method, to be checked, name
      #
      # @return [Symbol]
      attr_reader :method_name
    end
  end
end
