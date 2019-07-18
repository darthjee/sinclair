# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Matchers::AddMethod do
  subject(:matcher) { described_class.new(method) }

  let(:method)   { :the_method }
  let(:klass)    { Class.new }
  let(:instance) { klass.new }

  describe '#to' do
    it do
      expect(matcher.to(klass.new)).to be_a(Sinclair::Matchers::AddMethodTo)
    end

    it 'returns an add_method_to' do
      expect(matcher.to(instance)).to eq(Sinclair::Matchers::AddMethodTo.new(instance, method))
    end
  end

  describe '#matches?' do
    it do
      expect { matcher.matches?(proc {}) }
        .to raise_error(
          SyntaxError, 'You should specify which instance the method is being added to' \
          "add_method(:#{method}).to(instance)"
        )
    end
  end

  describe '#supports_block_expectations?' do
    it do
      expect(matcher).to be_supports_block_expectations
    end
  end
end
