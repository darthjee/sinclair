class Sinclair
  module Matchers
    class AddMethod < RSpec::Matchers::BuiltIn::BaseMatcher
      attr_reader :method

      def matches?(_actual)
        raise SyntaxError, 'You should specify which instance the method is being added to' \
          "add_method(:#{method}).to(instance)"
      end

      def initialize(method = nil)
        @method = method
      end

      def to(instance = nil, &block)
        AddMethodTo.new(instance, method, &block)
      end

      def equal?(other)
        return unless other.class == self.class
        other.method == method
      end

      def supports_block_expectations?
        true
      end
    end
  end
end
