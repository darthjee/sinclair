# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddInstanceMethod is able to build an instance of
    # {Sinclair::Matchers::ChangeClassMethodOn}
    class ChangeClassMethod < AddMethod
      # @example Checking if a class method has changed
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
      #      builder.add_class_method(:the_method) { 10 }
      #      builder.build
      #      builder.add_class_method(:the_method) { 20 }
      #    end
      #
      #    it do
      #      expect{ builder.build }.to change_class_method(:the_method).on(klass)
      #    end
      #  end
      with_final_matcher :on, ChangeClassMethodOn

      private

      # @private
      #
      # Error description on wrong usage
      #
      # @return String
      def matcher_error
        'You should specify which class the method is being changed on' \
          "change_class_method(:#{method_name}).on(klass)"
      end
    end
  end
end
