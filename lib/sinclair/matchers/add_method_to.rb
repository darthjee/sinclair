class Sinclair
  module Matchers
    class AddMethodTo < RSpec::Matchers::BuiltIn::BaseMatcher
      attr_reader :method, :instance

      def initialize(instance, method)
        if instance.is_a?(Class)
          @instance_class = instance
        else
          @instance = instance
        end
        @method = method
      end

      def description
        "add method '#{method}' to #{instance_class} instances"
      end

      def failure_message_for_should
        "expected '#{method}' to be added to #{instance_class} but " \
          "#{@initial_state ? 'it already existed' : "it didn't"}"
      end

      def failure_message_for_should_not
        "expected '#{method}' not to be added to #{instance_class} but it was"
      end

      def matches?(event_proc)
        return false unless event_proc.is_a?(Proc)
        raise_block_syntax_error if block_given?
        perform_change(event_proc)
        changed?
      end

      def supports_block_expectations?
        true
      end

      def equal?(other)
        return unless other.class == self.class
        other.method == method &&
          other.instance == instance
      end

      protected

      def changed?
        !@initial_state && @final_state
      end

      def perform_change(event_proc)
        @initial_state = method_defined?
        event_proc.call
        @final_state = method_defined?
      end

      def method_defined?
        instance_class.method_defined?(method)
      end

      def instance_class
        @instance_class ||= instance.class
      end

      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the `add_method_to` matcher. ' \
          'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end
