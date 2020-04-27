# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinitions do
  subject(:definitions) { described_class.new }

  describe '#add' do
    let(:name) { :the_method }

    context 'when passing block' do
      it 'returns the resulting array' do
        expect(definitions.add(name) { RandomGenerator.rand })
          .to be_a(Array)
      end

      it 'returns an array of MethodDefinition' do
        expect(definitions.add(name) { RandomGenerator.rand }.first)
          .to be_a(Sinclair::MethodDefinition)
      end

      it 'creates a new BlockDefinition' do
        expect(definitions.add(name) { RandomGenerator.rand }.first)
          .to be_a(Sinclair::MethodDefinition::BlockDefinition)
      end
    end

    context 'when passing string' do
      it 'returns the resulting array' do
        expect(definitions.add(name, 'RandomGenerator.rand'))
          .to be_a(Array)
      end

      it 'returns an array of MethodDefinition' do
        expect(definitions.add(name, 'RandomGenerator.rand').last)
          .to be_a(Sinclair::MethodDefinition)
      end

      it 'creates a new StringDefinition' do
        expect(definitions.add(name, 'RandomGenerator.rand').last)
          .to be_a(Sinclair::MethodDefinition::StringDefinition)
      end
    end
  end
end
