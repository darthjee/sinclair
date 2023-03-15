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
          [{ a: 10, b: 'word', c: true, d: false, e: nil, f: :symbol }]
        end

        it 'returns a list of parameters' do
          expect(described_class.parameters_from(parameters))
            .to eq(['a = 10', 'b = "word"', 'c = true', 'd = false', 'e = nil', 'f = :symbol'])
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
          [{ a: 10, b: 'word', c: true, d: false, e: nil, f: :symbol }]
        end

        it 'returns a list of parameters' do
          expect(described_class.parameters_from(parameters, named: true))
            .to eq(['a: 10', 'b: "word"', 'c: true', 'd: false', 'e: nil', 'f: :symbol'])
        end
      end
    end
  end

  describe '.value_string' do
    context 'when value is nil' do
      it 'returns string representing nil' do
        expect(described_class.value_string(nil)).to eq('nil')
      end
    end

    context 'when value is a symbol' do
      it 'returns string representing a symbol' do
        expect(described_class.value_string(:symbol)).to eq(':symbol')
      end
    end

    context 'when value is a string' do
      it 'returns string representing a string' do
        expect(described_class.value_string('string')).to eq('"string"')
      end
    end

    context 'when value is a number' do
      it 'returns string representing a number' do
        expect(described_class.value_string(10)).to eq('10')
      end
    end

    context 'when value is a float' do
      it 'returns string representing a float' do
        expect(described_class.value_string(1.20)).to eq('1.2')
      end
    end

    context 'when value is a true' do
      it 'returns string representing a true' do
        expect(described_class.value_string(true)).to eq('true')
      end
    end

    context 'when value is a false' do
      it 'returns string representing a false' do
        expect(described_class.value_string(false)).to eq('false')
      end
    end

    context 'when value is a class' do
      it 'returns string representing a class' do
        expect(described_class.value_string(Sinclair::Model)).to eq('Sinclair::Model')
      end
    end

    context 'when value is a hash' do
      it 'returns string representing a Hash' do
        expect(described_class.value_string({ a: 10, 'b' => 'value' }))
          .to eq('{ :a => 10, "b" => "value" }')
      end
    end
  end
end
