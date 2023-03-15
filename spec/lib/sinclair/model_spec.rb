# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Model do
  describe '.with_attributes' do
    context 'when the call happens with no options' do
      subject(:klass) { described_class.for(*attributes) }

      let(:attributes) { %i[name] }

      it 'Returns a new class' do
        expect(klass.superclass)
          .to eq(described_class)
      end

      it 'returns a class with getter' do
        expect(klass.instance_method(:name))
          .to be_a(UnboundMethod)
      end

      it 'returns a class with setter' do
        expect(klass.instance_method(:name=))
          .to be_a(UnboundMethod)
      end

      context 'when reader is called' do
        let(:name) { SecureRandom.hex(10) }

        let(:model) do
          klass.new(name: name)
        end

        it do
          expect(model.name).to eq(name)
        end
      end

      context 'when setter is called' do
        let(:name)  { SecureRandom.hex(10) }
        let(:model) { klass.new(name: nil) }

        it do
          expect { model.name = name }
            .to change(model, :name)
            .from(nil)
            .to(name)
        end
      end
    end

    context 'when the call happens with reader options' do
      subject(:klass) { described_class.for(*attributes, **options) }

      let(:attributes) { %i[name] }
      let(:options)    { { writter: false } }

      it 'Returns a new class' do
        expect(klass.superclass)
          .to eq(described_class)
      end

      it 'returns a class with getter' do
        expect(klass.instance_method(:name))
          .to be_a(UnboundMethod)
      end

      it 'returns a class without setter' do
        expect { klass.instance_method(:name=) }
          .to raise_error(NameError)
      end

      context 'when reader is called' do
        let(:name) { SecureRandom.hex(10) }

        let(:model) { klass.new(name: name) }

        it do
          expect(model.name).to eq(name)
        end
      end
    end

    context 'when the call happens with defaults' do
      subject(:klass) do
        described_class.for({ name: 'John Doe' }, **{})
      end

      it 'Returns a new class' do
        expect(klass.superclass)
          .to eq(described_class)
      end

      it 'returns a class with getter' do
        expect(klass.instance_method(:name))
          .to be_a(UnboundMethod)
      end

      it 'returns a class with setter' do
        expect(klass.instance_method(:name=))
          .to be_a(UnboundMethod)
      end

      context 'when reader is called' do
        let(:name) { SecureRandom.hex(10) }

        let(:model) { klass.new }

        it 'returns the dfault value' do
          expect(model.name).to eq('John Doe')
        end
      end

      context 'when setter is called' do
        let(:name)  { SecureRandom.hex(10) }
        let(:model) { klass.new }

        it do
          expect { model.name = name }
            .to change(model, :name)
            .from('John Doe')
            .to(name)
        end
      end
    end
  end
end
