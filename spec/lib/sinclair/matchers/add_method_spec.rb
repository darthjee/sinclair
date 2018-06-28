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

    it do
      expect(subject.to(instance)).to eq(Sinclair::Matchers::AddMethodTo.new(instance, method))
    end
  end
end
