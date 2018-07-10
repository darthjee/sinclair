# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Matchers::AddMethod do
  subject { described_class.new(method) }

  let(:method)   { :the_method }
  let(:klass)    { Class.new }
  let(:instance) { klass.new }

  describe '#to' do
    it do
      expect(subject.to(klass.new)).to be_a(Sinclair::Matchers::AddMethodTo)
    end

    it 'returns an add_method_to' do
      expect(subject.to(instance)).to eq(Sinclair::Matchers::AddMethodTo.new(instance, method))
    end
  end

  describe '#matches?' do
    it do
      expect do
        subject.matches?(proc {})
      end.to raise_error(
        SyntaxError, 'You should specify which instance the method is being added to' \
          "add_method(:#{method}).to(instance)"
      )
    end
  end
end
