require 'spec_helper'

describe ConcernBuilder do
  let(:options) { {} }
  let(:instance) { ConcernBuilder::Dummy.new }
  subject { builder_class.new(ConcernBuilder::Dummy, options) }

  before do
    subject.init
    subject.build
  end

  context 'when extending the class' do
    let(:builder_class) { described_class::Dummy::Builder }

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
end
