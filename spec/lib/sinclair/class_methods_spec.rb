# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ClassMethods do
  subject(:builder) { builder_class.new(dummy_class, options) }

  let(:options)       { {} }
  let(:instance)      { dummy_class.new }
  let(:dummy_class)   { Class.new }
  let(:builder_class) { Sinclair }

  describe '.build' do
    let(:block) do
      method_name = :some_method
      value = 1

      proc do
        add_method(method_name) { value }
      end
    end

    it 'executes the block and builds' do
      expect { builder_class.build(dummy_class, **options, &block) }
        .to add_method(:some_method).to(dummy_class)
    end

    context 'when the method is built and called' do
      before do
        builder_class.build(dummy_class, **options, &block)
      end

      it 'returns the value' do
        expect(instance.some_method).to eq(1)
      end
    end

    context 'when no block is given' do
      let(:builder_class) do
        Class.new(Sinclair) do
          def build
            add_method(:some_method) { 1 }
            super
          end
        end
      end

      it 'executes the block and builds' do
        expect { builder_class.build(dummy_class, **options) }
          .to add_method(:some_method).to(dummy_class)
      end
    end

    context 'when a block is given and initialization contains more arguments' do
      let(:builder_class) { ComplexBuilder }
      let(:value)         { Random.rand(10..30) }
      let(:power)         { Random.rand(3..5) }
      let(:result)        { value ** power }

      it 'executes the block and builds' do
        expect { builder_class.build(dummy_class, value, power, &:add_default) }
          .to add_method(:result).to(dummy_class)
      end

      context 'when the method is called' do
        before { builder_class.build(dummy_class, value, power, &:add_default) }

        it 'returns the evaluated value' do
          expect(instance.result).to eq(result)
        end
      end
    end
  end
end
