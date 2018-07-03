class Sinclair
  module Matchers
    class AddMethodTo < RSpec::Matchers::BuiltIn::BaseMatcher
      attr_reader :method, :instance, :block

      def initialize(instance, method, &block)
        @instance = instance
        @method = method
        @block = block
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
        @event_proc = event_proc
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
          other.evaluated_instance == evaluated_instance
      end

      protected

      def changed?
        !@initial_state && @final_state
      end

      def perform_change(event_proc)
        @initial_state = evaluated_instance.respond_to?(method)
        @evaluated_instance = nil
        event_proc.call
        @final_state = evaluated_instance.respond_to?(method)
      end

      def evaluated_instance
        @evaluated_instance ||= instance || block.call
      end

      def instance_class
        @instance_class ||= evaluated_instance.class
      end

      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the `add_method_to` matcher. ' \
          'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end
