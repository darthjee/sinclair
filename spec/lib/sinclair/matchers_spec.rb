require 'spec_helper'

describe Sinclair::Matchers do
  describe '#add_method' do
    it 'has been added to DSL' do
      expect(respond_to?(:add_method)).to be_truthy
    end

    it do
      expect(add_method(:method_name)).to be_a(described_class::AddMethod)
    end

    it 'returns the matcher with correct argument' do
      expect(add_method(:method_name)).to eq(described_class::AddMethod.new(:method_name))
    end
  end
end
