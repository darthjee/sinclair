# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    class AddMethod < RSpec::Matchers::BuiltIn::BaseMatcher
      # @param method [String,Symbol] the method, to be checked, name
      def initialize(method)
        @method = method
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
        other.method == method
      end

      alias == equal?

      protected

      # @private
      attr_reader :method
    end
  end
end
