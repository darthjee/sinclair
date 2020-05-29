# frozen_string_literal: true

class Sinclair
  module Matchers
    class ChangeInstanceMethodOn < ChangeMethodOn
      def initialize(target, method_name)
        if target.is_a?(Class)
          @klass = target
        else
          @instance = target
        end

        super(method_name)
      end

      def description
        "change method '#{method_name}' on #{klass} instances"
      end

      def failure_message_for_should
        "expected '#{method_name}' to be changed on #{klass} but " \
          "#{@initial_state ? "it didn't" : "it didn't exist"}"
      end

      def failure_message_for_should_not
        "expected '#{method_name}' not to be changed on #{klass} but it was"
      end

      protected

      attr_reader :instance

      def klass
        @klass ||= instance.class
      end

      private

      def state
        klass.method_defined?(method_name) &&
          klass.instance_method(method_name)
      end

      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the `change_instance_method_on` matcher. ' \
          'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end
