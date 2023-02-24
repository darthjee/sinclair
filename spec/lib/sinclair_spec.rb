# frozen_string_literal: true

require 'spec_helper'

describe Sinclair do
  subject(:builder) { builder_class.new(dummy_class, options) }

  let(:options)       { {} }
  let(:instance)      { dummy_class.new }
  let(:dummy_class)   { Class.new }
  let(:builder_class) { described_class }

  describe '#add_method' do
    context 'when extending the class' do
      let(:builder_class) { described_class::DummyBuilder }

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

      context "when describing a method using a block specific type" do
        it 'creates a method with the block' do
          expect(instance.type_block).to eq(3)
        end
      end

      context "when describing a method using a string specific type" do
        it 'creates a method with the string' do
          expect(instance.type_string).to eq(10)
        end
      end

      context "when describing a method using a call specific type for attr_acessor" do
        let(:value) { Random.rand }

        it 'creates acessors' do
          expect { instance.some_attribute = value }
            .to change(instance, :some_attribute)
            .from(nil).to(value)
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
      context 'when declaring a method with a block' do
        before do
          builder.add_method(:blocked) { 1 }
          builder.add_method(:blocked) { 2 }
          builder.build
        end

        it 'respect the order of method addtion' do
          expect(instance.blocked).to eq(2)
        end
      end

      context 'when declaring a method string' do
        before do
          builder.add_method(:string, '1')
          builder.add_method(:string, '2')
          builder.build
        end

        it 'respect the order of method addtion' do
          expect(instance.string).to eq(2)
        end
      end

      context 'when declaring block and string' do
        before do
          builder.add_method(:value) { 1 }
          builder.add_method(:value, '2')
          builder.build
        end

        it 'respect the order of method addtion' do
          expect(instance.value).to eq(2)
        end
      end

      context 'when declaring string and block' do
        before do
          builder.add_method(:value, '1')
          builder.add_method(:value) { 2 }
          builder.build
        end

        it 'respect the order of method addtion' do
          expect(instance.value).to eq(2)
        end
      end
    end
  end

  describe '#eval_and_add_method' do
    context 'when defining the method once' do
      before do
        builder.add_method(:value, '@value ||= 0')
        builder.eval_and_add_method(:defined) do
          "@value = value + #{options_object.increment || 1}"
        end
        builder.build
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
        builder.add_method(:value,   '@value ||= 0')
        builder.add_method(:defined, '100')
        builder.eval_and_add_method(:defined) do
          "@value = value + #{options_object.increment || 1}"
        end
        builder.build
      end

      it 'redefines it' do
        expect(instance.defined).to eq(1)
        expect(instance.defined).to eq(2)
      end
    end

    context 'when readding it' do
      before do
        builder.add_method(:value, '@value ||= 0')
        builder.eval_and_add_method(:defined) do
          "@value = value + #{options_object.increment || 1}"
        end
        builder.add_method(:defined, '100')
        builder.build
      end

      it 'redefines it' do
        expect(instance.defined).to eq(100)
      end
    end
  end

  describe '#add_class_method' do
    context 'when extending the class' do
      let(:builder_class) { described_class::DummyClassBuilder }

      before do
        builder.init
        builder.build
      end

      context 'when describing a method with block' do
        it 'creates a method with the block' do
          expect(dummy_class.blocked).to eq(1)
        end
      end

      context 'when describing a method with string' do
        it 'creates a method using the string definition' do
          expect(dummy_class.defined).to eq(1)
          expect(dummy_class.defined).to eq(2)
        end
      end

      context 'when passing options' do
        let(:options) { { increment: 2 } }

        it 'parses the options' do
          expect(dummy_class.defined).to eq(2)
          expect(dummy_class.defined).to eq(4)
        end
      end
    end

    context 'when using the builder without extending' do
      context 'when declaring a method with a block' do
        before do
          builder.add_class_method(:blocked) { 1 }
          builder.add_class_method(:blocked) { 2 }
          builder.build
        end

        it 'respect the order of method addtion' do
          expect(dummy_class.blocked).to eq(2)
        end
      end

      context 'when declaring a method string' do
        before do
          builder.add_class_method(:string, '1')
          builder.add_class_method(:string, '2')
          builder.build
        end

        it 'respect the order of method addtion' do
          expect(dummy_class.string).to eq(2)
        end
      end

      context 'when declaring block and string' do
        before do
          builder.add_class_method(:value) { 1 }
          builder.add_class_method(:value, '2')
          builder.build
        end

        it 'respect the order of method addtion' do
          expect(dummy_class.value).to eq(2)
        end
      end

      context 'when declaring string and block' do
        before do
          builder.add_class_method(:value, '1')
          builder.add_class_method(:value) { 2 }
          builder.build
        end

        it 'respect the order of method addtion' do
          expect(dummy_class.value).to eq(2)
        end
      end
    end
  end
end
