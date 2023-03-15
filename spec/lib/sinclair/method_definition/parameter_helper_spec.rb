# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodDefinition::ParameterHelper do
  describe '.parameters_from' do
    context 'when parameters are not named' do
      context 'when there are no defaults' do
        it 'returns a list of parameters' do
          expect(described_class.parameters_from(%i[a b]))
            .to eq(%w[a b])
        end
      end

      context 'when there are defaults' do
        let(:parameters) do
          [{ a: 10, b: 'word', c: true, d: false }]
        end

        it 'returns a list of parameters' do
          expect(described_class.parameters_from(parameters))
            .to eq(['a = 10', 'b = "word"', 'c = true', 'd = false'])
        end
      end
    end

    context 'when parameters are named' do
      context 'when there are no defaults' do
        it 'returns a list of parameters' do
          expect(described_class.parameters_from(%i[a b], named: true))
            .to eq(%w[a: b:])
        end
      end

      context 'when there are defaults' do
        let(:parameters) do
          [{ a: 10, b: 'word', c: true, d: false }]
        end

        it 'returns a list of parameters' do
          expect(described_class.parameters_from(parameters, named: true))
            .to eq(['a: 10', 'b: "word"', 'c: true', 'd: false'])
        end
      end
    end
  end
end
