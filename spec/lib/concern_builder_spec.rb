require 'spec_helper'

describe ConcernBuilder do
  let(:options) { {} }
  let(:instance) { dummy_class.new }
  subject { builder_class.new(dummy_class, options) }

  context 'when extending the class' do
    let(:builder_class) { dummy_class::Builder }
    let(:dummy_class) { described_class::Dummy }

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

  context 'when using the builder without extending' do
    let(:builder_class) { described_class }
    let(:dummy_class) { Class.new }

    context 'when declaring a method with a block' do
      before do
        subject.add_method(:blocked) { 1 }
        subject.add_method(:blocked) { 2 }
        subject.build
      end

      it 'respect the order of method addtion' do
        expect(instance.blocked).to eq(2)
      end
    end

    context 'when declaring a method string' do
      before do
        subject.add_method(:string, '1')
        subject.add_method(:string, '2')
        subject.build
      end

      it 'respect the order of method addtion' do
        expect(instance.string).to eq(2)
      end
    end

    context 'when declaring a method using string or block' do
      context 'when declaring the block first' do
        before do
          subject.add_method(:value) { 1 }
          subject.add_method(:value, '2')
          subject.build
        end

        it 'respect the order of method addtion' do
          expect(instance.value).to eq(2)
        end
      end

      context 'when declaring the string first' do
        before do
          subject.add_method(:value, '1')
          subject.add_method(:value) { 2 }
          subject.build
        end

        it 'respect the order of method addtion' do
          expect(instance.value).to eq(2)
        end
      end
    end
  end
end
