# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::BlockDefinition do
  subject(:definition) do
    described_class.new(method_name, **options, &block)
  end

  let(:method_name) { :the_method }
  let(:block)       { proc { RandomGenerator.rand } }
  let(:options)     { {} }

  describe '#method_block' do
    let(:klass)     { Class.new }
    let(:instance)  { klass.new }
    let(:new_block) { definition.method_block }

    it 'returns the block' do
      expect(definition.method_block).to eq(block)
    end

    it 'returns a block with no cache' do
      expect(instance.instance_eval(&new_block))
        .not_to eq(instance.instance_eval(&new_block))
    end

    context 'when cache true is given' do
      let(:options) { { cached: true } }

      it 'returns the a new block' do
        expect(definition.method_block).to be_a(Proc)
      end

      it 'returns a block with cache' do
        expect(instance.instance_eval(&new_block))
          .to eq(instance.instance_eval(&new_block))
      end

      it 'returns a block that does not cache nil' do
        instance.instance_variable_set("@#{method_name}", nil)

        expect(instance.instance_eval(&new_block)).not_to be_nil
      end
    end

    context 'when cache full is given' do
      let(:options) { { cached: :full } }

      it 'returns the a new block' do
        expect(definition.method_block).to be_a(Proc)
      end

      it 'returns a block with cache' do
        expect(instance.instance_eval(&new_block))
          .to eq(instance.instance_eval(&new_block))
      end

      it 'returns a block that does caches nil' do
        instance.instance_variable_set("@#{method_name}", nil)

        expect(instance.instance_eval(&new_block)).to be_nil
      end
    end
  end
end
