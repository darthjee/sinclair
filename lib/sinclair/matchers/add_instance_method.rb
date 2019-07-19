# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddInstanceMethod is able to build an instance of {Sinclair::Matchers::AddInstanceMethodTo}
    class AddInstanceMethod < AddMethod
      # @abstract
      #
      # Raise a warning on the usage as this is only a builder for {AddInstanceMethodTo}
      #
      # @raise SyntaxError
      def matches?(_actual)
        raise SyntaxError, 'You should specify which instance the method is being added to' \
          "add_method(:#{method}).to(instance)"
      end

      # Creates a matcher AddInstanceMethodTo
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
      # @return [AddInstanceMethodTo] the correct matcher
      def to(target = nil)
        AddInstanceMethodTo.new(target, method)
      end
    end
  end
end
