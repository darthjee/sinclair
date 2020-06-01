# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Matchers::ChangeInstanceMethod do
  subject(:matcher) { described_class.new(method) }

  let(:method)   { :the_method }
  let(:klass)    { Class.new }
  let(:instance) { klass.new }

  describe '#on' do
    it do
      expect(matcher.on(klass.new)).to be_a(Sinclair::Matchers::ChangeInstanceMethodOn)
    end

    it 'returns an change_instance_method_on' do
      expect(matcher.on(instance))
        .to eq(Sinclair::Matchers::ChangeInstanceMethodOn.new(instance, method))
    end
  end

  describe '#matches?' do
    it do
      expect { matcher.matches?(proc {}) }
        .to raise_error(
          SyntaxError, 'You should specify which instance the method is being changed on' \
          "change_method(:#{method}).on(instance)"
        )
    end
  end

  describe '#supports_block_expectations?' do
    it do
      expect(matcher).to be_supports_block_expectations
    end
  end
end
