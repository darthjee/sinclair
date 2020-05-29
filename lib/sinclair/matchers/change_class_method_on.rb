# frozen_string_literal: true

class Sinclair
  module Matchers
    class ChangeClassMethodOn < Base
      def initialize(target, method_name)
        @klass = target
        super(method_name)
      end

      def matches?(event_proc)
        return false unless event_proc.is_a?(Proc)

        raise_block_syntax_error if block_given?
        perform_change(event_proc)
        check
      end

      def description
        "change class method '#{method_name}' on #{klass}"
      end

      def failure_message_for_should
        "expected class method '#{method_name}' to be changed on #{klass} but " \
          "#{@initial_state ? "it didn't" : "it didn't exist"}"
      end

      def failure_message_for_should_not
        "expected class method '#{method_name}' not to be changed on #{klass} but it was"
      end

      alias failure_message failure_message_for_should
      alias failure_message_when_negated failure_message_for_should_not

      protected

      attr_reader :klass

      def check
        @initial_state && @initial_state != @final_state
      end

      def perform_change(event_proc)
        @initial_state = state
        event_proc.call
        @final_state = state
      end

      private

      def state
        klass.methods(false).include?(method_name.to_sym) \
          && klass.method(method_name)
      end

      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the `change_class_method_on` matcher. ' \
          'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end
