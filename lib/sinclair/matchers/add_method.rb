# frozen_string_literal: true

class Sinclair
  module Matchers
    # @author darthjee
    # AddMethod is able to build an instance of Sinclair::Matchers::AddMethodTo
    class AddMethod < RSpec::Matchers::BuiltIn::BaseMatcher
      # @api private
      # @abstract
      #
      # Raise a warning on the usage as this is only a builder for AddMethodTo
      #
      # @raise SyntaxError
      def matches?(_actual)
        raise SyntaxError, 'You should specify which instance the method is being added to' \
          "add_method(:#{method}).to(instance)"
      end

      # @api private
      #
      # Returns a new instance of AddMethod
      #
      # @param method [String,Symbol] the method, to be checked, name
      def initialize(method)
        @method = method
      end

      # @api public
      #
      # Creates a matcher AddMethodTo
      #
      # @overload to(klass)
      #   @param [Class] klass
      #     class where the method should be added to
      #
      # @overload to(instance)
      #   @param [Object] instance
      #     instance of the class where the method should be added to
      #
      # @example Using inside RSpec and checking Class
      #   RSpec.describe "MyBuilder" do
      #     let(:clazz)   { Class.new }
      #     let(:builder) { Sinclair.new(clazz) }
      #
      #     before do
      #       builder.add_method(:new_method, "2")
      #     end
      #
      #     it do
      #       expect { builder.build }.to add_method(:new_method).to(clazz)
      #     end
      #   end
      #
      #   # Outputs
      #   # 'should add method 'new_method' to #<Class:0x000056441bf46608> instances'
      # @example Using inside RSpec and checking instance
      #   RSpec.describe "MyBuilder" do
      #     let(:clazz)    { Class.new }
      #     let(:builder)  { Sinclair.new(clazz) }
      #     let(:instance) { clazz.new }
      #
      #     before do
      #       builder.add_method(:the_method, "true")
      #     end
      #
      #     it do
      #       expect { builder.build }.to add_method(:the_method).to(instance)
      #     end
      #   end
      #
      #   # Outputs
      #   # 'should add method 'the_method' to #<Class:0x000056441bf46608> instances'
      #
      # @return [AddMethodTo] the correct matcher
      def to(target = nil)
        AddMethodTo.new(target, method)
      end

      # @api private
      #
      # definition needed for block matchers
      #
      # @return [Boolean]
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
        other.method == method
      end

      alias == equal?

      protected

      # @api private
      # @private
      attr_reader :method
    end
  end
end
