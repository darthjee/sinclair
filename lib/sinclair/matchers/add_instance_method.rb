# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddInstanceMethod is able to build an instance of {Sinclair::Matchers::AddInstanceMethodTo}
    #
    # @example Using inside RSpec and checking Class
    #   RSpec.configure do |config|
    #     config.include Sinclair::Matchers
    #   end
    #
    #   class MyModel
    #   end
    #
    #   RSpec.describe "MyBuilder" do
    #     let(:clazz)   { Class.new(MyModel) }
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
    #
    # @example Using inside RSpec and checking instance
    #   RSpec.configure do |config|
    #     config.include Sinclair::Matchers
    #   end
    #
    #   class MyModel
    #   end
    #
    #   RSpec.describe "MyBuilder" do
    #     let(:clazz)    { Class.new(MyModel) }
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
    class AddInstanceMethod < Base
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
      # @return [AddInstanceMethodTo] the correct matcher
      def to(target = nil)
        AddInstanceMethodTo.new(target, method_name)
      end

      private

      def matcher_error
        'You should specify which instance the method is being added to' \
          "add_method(:#{method_name}).to(instance)"
      end
    end
  end
end
