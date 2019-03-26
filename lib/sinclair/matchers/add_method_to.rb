# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddMethodTo checks whether a method was or not added by the call of a block
    #
    # This is used with a RSpec DSL method add_method(method_name).to(class_object)
    #
    # @author darthjee
    #
    # @example
    #  RSpec.configure do |config|
    #    config.include Sinclair::Matchers
    #  end
    #
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
      # @private
      #
      # Returns a new instance of AddMethodTo
      #
      # @overload initialize(klass, method)
      #   @param [Class] klass
      #     class where the method should be added to
      #
      # @overload initialize(instance, method)
      #   @param [Object] klass
      #     instance of the class where the method should be added to
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

      # @private
      #
      # Returnst expectaton description
      #
      # @return [String]
      def description
        "add method '#{method}' to #{klass} instances"
      end

      # @private
      #
      # Returns message on expectation failure
      #
      # @return [String]
      def failure_message_for_should
        "expected '#{method}' to be added to #{klass} but " \
          "#{@initial_state ? 'it already existed' : "it didn't"}"
      end

      # @private
      #
      # Returns message on expectation failure for negative expectation
      #
      # @return [String]
      def failure_message_for_should_not
        "expected '#{method}' not to be added to #{klass} but it was"
      end

      # @private
      #
      # Checks if expectation is true or not
      #
      # @return [Boolean] expectation check
      def matches?(event_proc)
        return false unless event_proc.is_a?(Proc)
        raise_block_syntax_error if block_given?
        perform_change(event_proc)
        added?
      end

      # definition needed for block matchers
      def supports_block_expectations?
        true
      end

      # @api private
      #
      # Checkes if another instnce is equal self
      #
      # @return [Boolean]
      def equal?(other)
        return unless other.class == self.class
        other.method == method &&
          other.instance == instance
      end

      alias == equal?
      alias failure_message failure_message_for_should
      alias failure_message_when_negated failure_message_for_should_not

      protected

      # @api private
      # @private
      attr_reader :method, :instance

      private

      # @private
      #
      # Checks if a method was added (didn't exist before)
      #
      # @return Boolean
      def added?
        !@initial_state && @final_state
      end

      # @private
      #
      # Call block to check if it aded a method or not
      #
      # @return [Boolan]
      def perform_change(event_proc)
        @initial_state = method_defined?
        event_proc.call
        @final_state = method_defined?
      end

      # @private
      #
      # Checks if class has instance method defined
      #
      # @return [Boolean]
      def method_defined?
        klass.method_defined?(method)
      end

      # @private
      #
      # Class to be analised
      #
      # @return [Class]
      def klass
        @klass ||= instance.class
      end

      # @private
      #
      # Raises when block was not given
      #
      # @raise SyntaxError
      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the `add_method_to` matcher. ' \
          'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end
