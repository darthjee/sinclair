# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddClassMethod is able to build an instance of {Sinclair::Matchers::AddClassMethodTo}
    #
    # @example
    #   RSpec.describe 'MyBuilder' do
    #     let(:clazz)   { Class.new }
    #
    #     let(:block) do
    #       proc do
    #         clazz.define_singleton_method(:new_method) { 2 }
    #       end
    #     end
    #
    #     it do
    #       expect(&block).to add_class_method(:new_method).to(clazz)
    #     end
    #   end
    #
    #   # outputs
    #   # should add method class_method 'new_method' to #<Class:0x000055b4d0a25c80>
    class AddClassMethod < AddMethod
      # @abstract
      #
      # Raise a warning on the usage as this is only a builder for AddClassMethodTo
      #
      # @raise SyntaxError
      def matches?(_actual)
        raise SyntaxError, 'You should specify which class the method is being added to' \
          "add_class_method(:#{method}).to(klass)"
      end

      # Creates a matcher {AddClassMethodTo}
      #
      # @param target [Class]
      #   class where the method should be added to
      #
      # @return [AddClassMethodTo] the correct matcher
      def to(target = nil)
        AddClassMethodTo.new(target, method)
      end
    end
  end
end
