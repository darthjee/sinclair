require 'spec_helper'

describe Sinclair do
  let(:options) { {} }
  let(:instance) { dummy_class.new }
  let(:dummy_class) { Class.new }
  let(:builder_class) { described_class }
  subject { builder_class.new(dummy_class, options) }

  describe '#build' do
    context 'when there is a method added' do
      before do
        subject.add_method(:x) { 1 }
      end

      it 'changes the class adding a method' do
        expect do
          subject.build
        end.to change { instance.respond_to?(:x) }.from(false).to(true)
      end
    end
  end

  describe '#add_method' do
    it_behaves_like 'a class extending sinclair' do
      let(:builder_class) { described_class::DummyBuilder }
    end

    context 'when using the builder without extending' do
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

  describe '#eval_and_add_method' do
    context 'when defining the method once' do
      before do
        subject.add_method(:value, "@value ||= 0")
        subject.eval_and_add_method(:defined) { "@value = value + #{ options_object.increment || 1 }" }
        subject.build
      end

      it 'creates a method using the string definition' do
        expect(instance.defined).to eq(1)
        expect(instance.defined).to eq(2)
      end

      context 'when passing options' do
        let(:options) { { increment: 2 } }

        it 'parses the options' do
          expect(instance.defined).to eq(2)
          expect(instance.defined).to eq(4)
        end
      end
    end

    context 'when redefining a method already added' do
      before do
        subject.add_method(:value,   "@value ||= 0")
        subject.add_method(:defined, "100")
        subject.eval_and_add_method(:defined) { "@value = value + #{ options_object.increment || 1 }" }
        subject.build
      end

      it 'redefines it' do
        expect(instance.defined).to eq(1)
        expect(instance.defined).to eq(2)
      end
    end

    context 'when readding it' do
      before do
        subject.add_method(:value,   "@value ||= 0")
        subject.eval_and_add_method(:defined) { "@value = value + #{ options_object.increment || 1 }" }
        subject.add_method(:defined, "100")
        subject.build
      end

      it 'redefines it' do
        expect(instance.defined).to eq(100)
      end
    end
  end
end
