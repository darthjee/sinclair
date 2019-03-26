# frozen_string_literal: true

class Sinclair
  module Matchers
    # AddMethod is able to build an instance of Sinclair::Matchers::AddMethodTo
    class AddMethod < RSpec::Matchers::BuiltIn::BaseMatcher
      # as any matcher is expected to implement matches?, we raise a warning on
      # the usage as this is only a builder for AddMethodTo
      def matches?(_actual)
        raise SyntaxError, 'You should specify which instance the method is being added to' \
          "add_method(:#{method}).to(instance)"
      end

      # @param method [String,Symbol] the method, to be checked, name
      def initialize(method)
        @method = method
      end

      # @return [AddMethodTo] the correct matcher
      # @overload to(klass)
      #   @param [Class] klass
      #     class where the method should be added to
      #
      # @overload to(instance)
      #   @param [Object] instance
      #     instance of the class where the method should be added to
      def to(target = nil)
        AddMethodTo.new(target, method)
      end

      def equal?(other)
        return unless other.class == self.class
        other.method == method
      end

      alias == equal?

      # definition needed for block matchers
      def supports_block_expectations?
        true
      end

      protected

      attr_reader :method
    end
  end
end
