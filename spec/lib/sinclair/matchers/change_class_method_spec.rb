# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Matchers::ChangeClassMethod do
  subject(:matcher) { described_class.new(method) }

  let(:method)   { :the_method }
  let(:klass)    { Class.new }

  describe '#on' do
    it do
      expect(matcher.on(klass.new))
        .to be_a(Sinclair::Matchers::ChangeClassMethodOn)
    end

    it 'returns an add_class_method_to' do
      expect(matcher.on(klass))
        .to eq(Sinclair::Matchers::ChangeClassMethodOn.new(klass, method))
    end
  end

  describe '#matches?' do
    it do
      expect { matcher.matches?(proc {}) }
        .to raise_error(
          SyntaxError, 'You should specify which class the method is being changed on' \
          "change_class_method(:#{method}).on(klass)"
        )
    end
  end

  describe '#supports_block_expectations?' do
    it do
      expect(matcher).to be_supports_block_expectations
    end
  end
end
