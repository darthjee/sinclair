require 'spec_helper'

describe Sinclair::Matchers do
  describe '#add_method' do
    it 'has been added to DSL' do
      expect(respond_to?(:add_method)).to be_truthy
    end

    it 'returns a matcher' do
      expect(add_method(:method_name)).to be_a(described_class::AddMethod)
    end

    it 'returns the matcher with correct argument' do
      expect(add_method(:method_name).method).to eq(:method_name)
    end
  end
end
