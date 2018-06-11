require 'spec_helper'

shared_examples 'a class extending sinclair' do
  context 'when extending the class' do
    before do
      subject.init
      subject.build
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
end
