class Sinclair
  module Matchers
    class AddMethod < RSpec::Matchers::BuiltIn::BaseMatcher
      attr_reader :method

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
    end
  end
end
