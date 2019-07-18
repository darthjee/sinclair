# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Matchers::AddClassMethod do
  subject(:matcher) { described_class.new(method) }

  let(:method)   { :the_method }
  let(:klass)    { Class.new }

  describe '#to' do
    it do
      expect(matcher.to(klass.new)).to be_a(Sinclair::Matchers::AddClassMethodTo)
    end

    it 'returns an add_method_to' do
      expect(matcher.to(klass)).to eq(Sinclair::Matchers::AddClassMethodTo.new(klass, method))
    end
  end

  describe '#matches?' do
    it do
      expect { matcher.matches?(proc {}) }
        .to raise_error(
          SyntaxError, 'You should specify which instance the method is being added to' \
          "add_class_method(:#{method}).to(klass)"
        )
    end
  end
end

