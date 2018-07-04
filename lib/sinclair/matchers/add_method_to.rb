class Sinclair
  module Matchers
    # AddMethodTo checks whether a method was or not added by the call of a block
    #
    # This is used with a RSpec DSL method add_method(method_name).to(class_object)
    #
    # @author darthjee
    #
    # @example
    #  class MyModel
    #  end
    #
    #  RSpec.describe 'my test' do
    #    let(:klass)   { Class.new(MyModel) }
    #    let(:builder) { Sinclair.new(klass) }
    #
    #    before do
    #      builder.add_method(:class_name, 'self.class.name')
    #    end
    #
    #    it do
    #      expect { builder.build }.to add_method(:class_name).to(klass)
    #    end
    #  end
    class AddMethodTo < RSpec::Matchers::BuiltIn::BaseMatcher
      # @param target
      #   target class / instance where the method should be added
      #
      # @param method
      #   method name
      def initialize(target, method)
        if target.is_a?(Class)
          @klass = target
        else
          @instance = target
        end
        @method = method
      end

      def description
        "add method '#{method}' to #{klass} instances"
      end

      def failure_message_for_should
        "expected '#{method}' to be added to #{klass} but " \
          "#{@initial_state ? 'it already existed' : "it didn't"}"
      end

      def failure_message_for_should_not
        "expected '#{method}' not to be added to #{klass} but it was"
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

      attr_reader :method, :instance

      private

      def changed?
        !@initial_state && @final_state
      end

      def perform_change(event_proc)
        @initial_state = method_defined?
        event_proc.call
        @final_state = method_defined?
      end

      def method_defined?
        klass.method_defined?(method)
      end

      def klass
        @klass ||= instance.class
      end

      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the `add_method_to` matcher. ' \
          'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end
