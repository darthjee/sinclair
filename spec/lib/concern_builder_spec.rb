require 'spec_helper'

describe ConcernBuilder do
  class ConcernBuilder::Dummy
    def initialize
      @value = 0
    end
  end

  class ConcernBuilder::Dummy::Builder < ConcernBuilder
    def init
      add_method(:blocked) { 1 }
      add_method(:defined, "@value = @value + #{ options_object.try(:increment) || 1 }")
    end
  end

  let(:options) { {} }
  let(:dummy_builder) { described_class::Dummy::Builder }
  let(:builder) { dummy_builder.new(ConcernBuilder::Dummy, options) }
  let(:instance) { ConcernBuilder::Dummy.new }

  before do
    builder.init
    builder.build
  end

  context 'when describing a method with block' do
    it 'creates a method with the block' do
      expect(instance.blocked).to eq(1)
    end
  end

  context 'when describing a method with string' do
    it 'creates a method using the string definition' do
      expect(instance.defined).to eq(1)
      expect(instance.defined).to eq(2)
    end
  end

  context 'when passing options' do
    let(:options) { { increment: 2 } }
    it 'parses the options' do
      expect(instance.defined).to eq(2)
      expect(instance.defined).to eq(4)
    end
  end
end
