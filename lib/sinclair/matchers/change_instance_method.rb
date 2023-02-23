# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddInstanceMethod is able to build an instance of
    # {Sinclair::Matchers::ChangeInstanceMethodOn}
    class ChangeInstanceMethod < AddMethod
      # @example Checking if an instance method has changed
      #  RSpec.configure do |config|
      #    config.include Sinclair::Matchers
      #  end
      #
      #  class MyModel
      #  end
      #
      #  RSpec.describe 'my test' do
      #    let(:builder) { Sinclair.new(klass) }
      #    let(:klass)   { Class.new(MyModel) }
      #
      #    before do
      #      builder.add_method(:the_method) { 10 }
      #      builder.build
      #      builder.add_method(:the_method) { 20 }
      #    end
      #
      #    it do
      #      expect{ builder.build }.to change_method(:the_method).on(klass)
      #    end
      #  end
      #
      # @example Checking if an instance method has changed on an instance
      #  RSpec.configure do |config|
      #    config.include Sinclair::Matchers
      #  end
      #
      #  class MyModel
      #  end
      #
      #  RSpec.describe 'my test' do
      #    let(:builder)  { Sinclair.new(klass) }
      #    let(:instance) { klass.new }
      #    let(:klass)    { Class.new(MyModel) }
      #
      #    before do
      #      builder.add_method(:the_method) { 10 }
      #      builder.build
      #      builder.add_method(:the_method) { 20 }
      #    end
      #
      #    it do
      #      expect{ builder.build }.to change_method(:the_method).on(instance)
      #    end
      #  end
      with_final_matcher :on, ChangeInstanceMethodOn

      private

      # @private
      #
      # Error description on wrong usage
      #
      # @return String
      def matcher_error
        'You should specify which instance the method is being changed on' \
          "change_method(:#{method_name}).on(instance)"
      end
    end
  end
end
