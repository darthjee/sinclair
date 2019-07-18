# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    # AddMethod is able to build an instance of {Sinclair::Matchers::AddClassMethodTo}
    class AddClassMethod < RSpec::Matchers::BuiltIn::BaseMatcher
      # @abstract
      #
      # Raise a warning on the usage as this is only a builder for AddClassMethodTo
      #
      # @raise SyntaxError
      def matches?(_actual)
        raise SyntaxError, 'You should specify which class the method is being added to' \
          "add_class_method(:#{method}).to(klass)"
      end

      # Returns a new instance of AddMethod
      #
      # @param method [String,Symbol] the method, to be checked, name
      def initialize(method)
        @method = method
      end

      # Creates a matcher AddClassMethodTo
      #
      # @param [Class] klass
      #   class where the method should be added to
      #
      # @return [AddClassMethodTo] the correct matcher
      def to(target = nil)
        AddClassMethodTo.new(target, method)
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
