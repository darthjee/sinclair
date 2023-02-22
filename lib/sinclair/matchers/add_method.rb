# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    #
    # Common methods for matchers
    class AddMethod < Base
      # @api public
      #
      # Builds final matcher
      #
      # The matcher checks if a method was added
      # to a class or instance
      #
      # @param [target] target where the method will be added
      #
      # @return [Sinclair::Matchers::Base]
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
      def to(target = nil)
        add_method_to_class.new(target, method_name)
      end

      # @abstract
      #
      # Raise a warning on the usage as this is only a builder
      #
      # @raise SyntaxError
      def matches?(_actual)
        raise SyntaxError, matcher_error
      end
    end
  end
end
