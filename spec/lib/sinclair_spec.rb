# frozen_string_literal: true

require 'spec_helper'

describe Sinclair do
  subject(:builder) { builder_class.new(dummy_class, options) }

  let(:options)       { {} }
  let(:instance)      { dummy_class.new }
  let(:dummy_class)   { Class.new }
  let(:builder_class) { described_class }

  describe '.build' do
    let(:block) do
      method_name = :some_method
      value = 1

      proc do
        add_method(:some_method) { value }
      end
    end

    it 'executes the block and builds' do
      expect { builder_class.build(dummy_class, options, &block) }
        .to add_method(:some_method).to(dummy_class)
    end

    context 'after the method is built and called' do
      before do
        builder_class.build(dummy_class, options, &block)
      end

      it 'returns the value' do
        expect(dummy_class.new.some_method).to eq(1)
      end
    end
  end

  describe '#add_method' do
    let(:object) { instance }

    it_behaves_like 'A sinclair builder', :instance
  end

  describe '#add_class_method' do
    let(:object) { dummy_class }

    it_behaves_like 'A sinclair builder', :class
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
end
